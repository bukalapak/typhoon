# frozen_string_literal: true

class CalculateLoadTestReport < ApplicationJob
  require "./lib/typhoon/generate_report.rb"
  require "csv"

  queue_as :default
  self.queue_adapter = :async

  # :reek:DuplicateMethodCall
  def perform(jmeter, load_test)
    generate_report = GenerateReport.new(jmeter.artifact)
    aggregate_report = File.read("/tmp/typhoon/aggregate/#{generate_report.aggregate}.csv")
    aggregate_report_table = ::CSV.parse(aggregate_report, headers: true)
    aggregate_report_table.delete(aggregate_report_table.size - 1)
    error_count = 0
    aggregate_report_table.each do |aggregate|
      load_test_report = LoadTestReport.new
      load_test_report.jmeter_id = jmeter.id
      load_test_report.load_test_id = load_test.id
      load_test_report.threshold = load_test.threshold
      load_test_report.label = aggregate["Label"]
      load_test_report.samples = aggregate["# Samples"]
      load_test_report.average = aggregate["Average"]
      load_test_report.percentile_90 = aggregate["90% Line"]
      load_test_report.percentile_95 = aggregate["95% Line"]
      load_test_report.percentile_99 = aggregate["99% Line"]
      load_test_report.min = aggregate["Min"]
      load_test_report.max = aggregate["Max"]
      load_test_report.error_rate = aggregate["Error %"]

      previous_result = LoadTestReport.where(load_test_id: load_test.id).where(label: load_test_report.label).last
      if previous_result
        load_test_report.percentile_90_previous = previous_result.percentile_90
        load_test_report.percentile_95_previous = previous_result.percentile_95
        load_test_report.percentile_99_previous = previous_result.percentile_99
      end

      if load_test_report.percentile_90 > load_test_report.threshold || load_test_report.error_rate > 0
        load_test_report.status = "failed"
        error_count += 1
      else
        load_test_report.status = "passed"
      end

      load_test_report.save
    end
    if error_count > 0 && load_test.telegram_id
      load_test.notif_error
    end
  end
end
