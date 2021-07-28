# frozen_string_literal: true

class GenerateReport
  include ActiveStorage::Downloading

  attr_reader :blob

  def initialize(blob)
    @blob = blob
  end

  # :reek:FeatureEnvy
  def aggregate
    download_blob_to_tempfile do |file|
      aggregate = File.basename(file.path, ".jtl")
      `cd ./apache-jmeter-5.1.1/bin && ./JMeterPluginsCMD.sh --generate-csv /tmp/typhoon/aggregate/#{aggregate}.csv --input-jtl #{file.path} --plugin-type AggregateReport`
      return aggregate
    end
  end
end
