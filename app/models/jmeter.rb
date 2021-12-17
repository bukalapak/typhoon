# frozen_string_literal: true

class Jmeter < ApplicationRecord
  include Notification
  include DataCSV

  has_one_attached :csv
  has_one_attached :jmx_script
  has_one_attached :artifact

  validates :jmx_id, :threads, :ramp, :duration, :timeouts, :testing_type, presence: true
  validates :csv, attached: { message: "The file you choose need CSV" },
    file: { ext: ".csv", message: "The file extension need to be .csv" },
    if: :csv_needed?
  validates :threads, :ramp, :duration, :timeouts, numericality: {
    only_integer: true,
    other_than: 0
  }
  validates :threads, numericality: { greater_than_or_equal_to: 10 }
  validate :csv_matched?, :master_config_empty?, :empty_slave?, :csv_rows_less?

  before_save :insert_name, :attach_modified_jmx_script

  self.per_page = 5

  # :reek:FeatureEnvy
  def start
    self.update(status: "Running")
    notif_start(self)

    # Run jmeter script on master
    master_config = MasterConfiguration.last
    master_host = master_config.master_server_host

    Net::SSH.start(
      master_host,
      master_config.master_server_username,
      password: master_config.master_server_password,
      port: master_config.master_server_port
    ) do |ssh|
      output = ssh.exec! "truncate -s 0 #{Rails.configuration.jmeter["jtl_path"]} && #{master_config.master_server_jmeter_run_command} -Jserver.rmi.ssl.disable=true -J influxdb-host=#{master_config.influxdb_host} -Djava.rmi.server.hostname=#{master_host} -n -t #{Rails.configuration.jmeter["script_path"]} -l #{Rails.configuration.jmeter["jtl_path"]} -R#{SlaveServer.all.where(slave_type: self.testing_type, slave_status: 'ON').pluck("host").join(",")}"
      # TODO make this ouput info looks better
      puts output
    end
    self.update(status: "Stop")
    notif_finish(self)
  end

  # :reek:FeatureEnvy
  def stop
    master_config = MasterConfiguration.last
    Net::SSH.start(
      master_config.master_server_host,
      master_config.master_server_username,
      password: master_config.master_server_password,
      port: master_config.master_server_port
    ) do |ssh|
      ssh.exec! "./apache-jmeter-xx.xx.xx/bin/shutdown.sh"
    end
    notif_stop
  end

  def empty_slave?
    errors[:threads] << "There is no any Slaves, Add them first!" unless SlaveServer.all.size > 0
  end

  def csv_needed?
    Jmx.find(self.jmx_id).script.download.include? "CSV" if self.jmx_id?
  end

  def csv_matched?
    csv = self.csv
    return unless csv_needed? && csv.attached?
    errors[:csv] << "CSV file not matched" unless self.csv.download.split.first.split(/;|,/).size == Jmx.find(self.jmx_id).script.download.match(/variableNames\">(.+)</)[1].split(",").size
  end

  def csv_rows_less?
    return unless csv_needed? && csv.attached?
    csv = self.csv
    raw_csv_size = self.csv.download.split(/\r\n|\n/).size
    csv_on_jmx = Jmx.find(self.jmx_id).script.download.match(/variableNames\">(.+)</)[1].split(",")
    uploading_csv = self.csv.download.split.first.split(/;|,/)
    if csv_on_jmx == uploading_csv
      @csv_rows = raw_csv_size-1
    else
      @csv_rows = raw_csv_size
    end
    @csv_rows
    errors[:csv] << "CSV: Minimum Rows are 10" if @csv_rows < 10
  end

  def master_config_empty?
    errors[:threads] << "Master Configuration is Not Properly Configured" unless MasterConfiguration.last
  end

  def insert_name
    self.jmx_name = Jmx.find(self.jmx_id).name
  end

  def attach_modified_jmx_script
    params = {}
    params[:threads] = self.threads
    params[:ramp] = self.ramp
    params[:duration] = self.duration
    params[:timeouts] = self.timeouts
    jmx_file = Jmx.find(self.jmx_id).modify_script(params, self)
    jmx_file = csv_upload(jmx_file, self.csv.download, self.testing_type) if jmx_file.include? "CSV"
    self.jmx_script.attach(io: StringIO.new(jmx_file), filename: self.jmx_name)
  end

  # :reek:DuplicateMethodCall
  def upload_jmx_script_to_master
    master_config = MasterConfiguration.last
    self.update(status: "Upload JMX File")
    File.write(Rails.configuration.jmeter["script_path"], self.jmx_script.download)
    Net::SSH.start(
      master_config.master_server_host,
      master_config.master_server_username,
      password: master_config.master_server_password,
      port: master_config.master_server_port
    ) do |ssh|
      ssh.exec! "mkdir -p /tmp/typhoon/csv"
    end
    Net::SCP.upload!(
      master_config.master_server_host,
      master_config.master_server_username,
      Rails.configuration.jmeter["script_path"],
      Rails.configuration.jmeter["script_path"],
      ssh: {
        password: master_config.master_server_password,
        port: master_config.master_server_port
      }
    )
  end

  # :reek:DuplicateMethodCall
  def download_artifact
    master_config = MasterConfiguration.last
    self.update(status: "Downloading Artifact")
    Net::SCP.download!(
      master_config.master_server_host,
      master_config.master_server_username,
      Rails.configuration.jmeter["jtl_path"],
      Rails.configuration.jmeter["jtl_path"],
      ssh: {
        password: master_config.master_server_password,
        port: master_config.master_server_port
      }
    )
    self.artifact.attach(io: File.open(Rails.configuration.jmeter["jtl_path"]), filename: "jmeter_data.jtl")
  end

  def load_test?
    self.testing_type == "load-test"
  end
end
