# frozen_string_literal: true

class Jmx < ApplicationRecord
  has_one_attached :script

  validates :script, attached: true,
    file: { ext: ".jmx", message: "The file extension need to be .jmx" }
  validate :xml_valid?, :only_one_thread?, :only_one_csv?,
    :not_include_backend_listener, :has_test_plan, :no_need_params, if: :script_attached?

  before_save :insert_name

  def not_include_backend_listener
    script = self.script
    return unless script.attached?
    errors.add(:script, "Please remove any Backend Listener on JMX file!") if script.download.include? "BackendListener"
  end

  def script_attached?
    self.script.attached?
  end

  def insert_name
    self.name = self.script.filename
  end

  def modify_script(params, jmeter)
    jmx_file = self.script.download
    jmx_file = modify_backend_listener(jmx_file, jmeter)
    jmx_file = disable_view_result_tree(jmx_file)
    jmx_file = modify_params(jmx_file, params, jmeter)
    jmx_file
  end

  def xml_valid?
    errors[:script] << "The script must be a xml" unless self.script.download.include? "?xml version"
  end

  def modify_backend_listener(jmx_file, jmeter)
    backend_listener_xml = File.open("lib/typhoon/backend_listener_influxdb_rocks.xml").read
    backend_listener_xml.gsub!("typhoon", "typhoon_#{jmeter.testing_type.tr("-", "_")}")
    backend_listener_xml.gsub!("Ip.Host.Influx.DB", MasterConfiguration.last.influxdb_host) if Rails.env.development?
    jmx_file.gsub!(
      /<\/TestPlan>\n    <hashTree>\n/,
      "<\/TestPlan>\n    #{backend_listener_xml}"
    )
    jmx_file
  end

  def disable_view_result_tree(jmx_file)
    jmx_file.gsub!(
      /\"View Results Tree\" enabled=\"true\"/,
      "\"View Results Tree\" enabled=\"false\""
    )
    jmx_file
  end

  def has_test_plan
    unless self.script.download.include? "TestPlanGui"
      errors.add(:script, "Must has a Test Plan")
    end
  end

  def only_one_thread?
    errors[:script] << "Only 1 Thread allowed, remove the other first" if self.script.download.to_s.scan(/ThreadGroupGui/).length > 1
  end

  def only_one_csv?
    # The length should be given 3, because the CSVDataSet tags would appear 3 times for each CSV Data Set Config
    errors[:script] << "Only 1 CSV Data Set allowed, remove the other first" if self.script.download.to_s.scan(/CSVDataSet/).length > 3
  end

  def no_need_params
    http_request_class = self.script.download.to_s.scan(/HttpTestSampleGui/)

    http_request_class.each do
      errors[:script] << "HTTP Request's Name doesn't need any params" if self.script.download.to_s.match(/testname="\$\{/)
    end
  end

  # :reek:DuplicateMethodCall
  def modify_params(jmx_file, params, jmeter)
    jmx_file.gsub!(
      /num_threads\">(.+)</,
      "num_threads\">#{params[:threads] / SlaveServer.where(slave_type: jmeter.testing_type, slave_status: 'ON').size}<"
    )
    jmx_file.gsub!(
      /ramp_time\">(.+)</,
      "ramp_time\">#{params[:ramp]}<"
    )
    jmx_file.gsub!(
      /continue_forever\">(.+)</,
      "continue_forever\">true<"
    )
    jmx_file.gsub!(
      /duration\">(.+)</,
      "duration\">#{params[:duration]}<"
    )
    jmx_file.gsub!(
      /duration\"></,
      "duration\">#{params[:duration]}<"
    )
    jmx_file.gsub!(
      /connect_timeout\">(.+)</,
      "connect_timeout\">#{params[:timeouts]}<"
    )
    jmx_file.gsub!(
      /connect_timeout\"></,
      "connect_timeout\">#{params[:timeouts]}<"
    )
    jmx_file.gsub!(
      /response_timeout\">(.+)</,
      "response_timeout\">#{params[:timeouts]}<"
    )
    jmx_file.gsub!(
      /response_timeout\"></,
      "response_timeout\">#{params[:timeouts]}<"
    )
    jmx_file.gsub!(
      /ThreadGroup.scheduler\">false</,
      "ThreadGroup.scheduler\">true<"
    )
    jmx_file
  end
end
