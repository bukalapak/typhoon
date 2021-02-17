# frozen_string_literal: true

# Run Jmeter Job
class RunJmeterJob < ApplicationJob
  queue_as :default
  self.queue_adapter = :async

  def perform(jmeter)
    jmeter.upload_jmx_script_to_master
    jmeter.start
    jmeter.download_artifact
    jmeter.update(status: "Finished")
  end
end
