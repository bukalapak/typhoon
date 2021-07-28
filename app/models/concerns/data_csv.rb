# frozen_string_literal: true

module DataCSV
  extend ActiveSupport::Concern

  def csv_upload(jmx_file, csv, testing_type)
    # Clean csv directory
    `rm -rf /tmp/typhoon/csv/*`

    set_csv_header(jmx_file, csv) if jmx_file.match(/ignoreFirstLine">(.+)</)[1] == "true"
    split_csv_file(csv, testing_type)
    distribute_csv_file(testing_type)

    # Change jmeter CSV file path
    jmx_file.gsub!(/filename\">(.+)</, "filename\">#{Rails.configuration.jmeter["csv_file_path"]}<")
  end

  def split_csv_file(csv, testing_type)
    File.write(Rails.configuration.jmeter["csv_file_path"], csv)
    csv_size = `wc -l "#{Rails.configuration.jmeter["csv_file_path"]}"`.strip.split(" ")[0].to_i
    `cd /tmp/typhoon/csv && split -l #{csv_size.ceil(-1) / SlaveServer.where(slave_type: testing_type, slave_status: 'ON').size} #{Rails.configuration.jmeter["csv_file_path"]} csv-`
    # Remove master CSV file
    `rm #{Rails.configuration.jmeter["csv_file_path"]}`
  end

  def distribute_csv_file(testing_type)
    # Initiate slaves typhoon tmp folder
    slave_servers = SlaveServer.where(slave_type: testing_type, slave_status: 'ON')
    slave_servers.each do |slave|
      Net::SSH.start(
        slave.host,
        slave.username,
        password: slave.password,
        port: slave.port
      ) do |ssh|
        ssh.exec! "mkdir -p /tmp/typhoon/csv"
      end
    end
    slave_servers.each.with_index do |slave, index|
      Net::SCP.upload!(
        slave.host,
        slave.username,
        "#{Rails.configuration.jmeter["csv_path"]}/#{Dir.children(Rails.configuration.jmeter["csv_path"])[index]}",
        Rails.configuration.jmeter["csv_file_path"],
        ssh: {
          password: slave.password,
          port: slave.port
        }
      )
    end
  end

  def set_csv_header(jmx_file, csv)
    csv = csv.split("\n")
    csv.shift
    csv = csv.join("\n")
    jmx_file.gsub!(/ignoreFirstLine">(.+)</, "ignoreFirstLine\">false<")
    return jmx_file, csv
  end
end
