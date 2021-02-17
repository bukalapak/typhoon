# frozen_string_literal: true

class JmetersController < ApplicationController
  def start
    jmeter = Jmeter.new(start_params)
    jmeter.csv.attach(start_params[:csv])
    if jmeter.save
      jmeter.update(status: "Starting")
      RunJmeterJob.perform_later(jmeter)
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path, flash: { jmeter: jmeter.errors, start_params: start_params }
    end
  end

  def stop
    jmeter = Jmeter.new
    jmeter.stop
    redirect_back(fallback_location: root_path)
  end

  private

    # TODO create safe params for all method

    def start_params
      params.require(:jmeter).permit(:jmx_id, :csv, :threads, :ramp, :duration, :timeouts, :testing_type)
    end
end
