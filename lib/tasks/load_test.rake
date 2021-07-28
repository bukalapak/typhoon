# frozen_string_literal: true

namespace :load_test do
  desc "Load Testing"

  task start: :environment do
    Rails.logger = Logger.new(STDOUT)
    LoadTest.all.each do |load_test|
      jmeter = Jmeter.new
      jmeter.jmx_id = load_test.jmx_id
      jmeter.jmx_name = load_test.jmx_name
      jmeter.threads = load_test.threads
      jmeter.ramp = load_test.ramp
      jmeter.duration = load_test.duration
      jmeter.timeouts = load_test.timeouts
      jmeter.testing_type = "load-test"
      jmeter.csv.attach(io: StringIO.new(load_test.csv.download), filename: load_test.csv.filename) if load_test.csv.attached?

      if jmeter.save
        jmeter.update(status: "Starting")
        RunJmeterJob.perform_now(jmeter)
        CalculateLoadTestReport.perform_now(jmeter, load_test)
      end
    end
  end
end
