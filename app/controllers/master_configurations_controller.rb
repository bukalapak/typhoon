# frozen_string_literal: true

class MasterConfigurationsController < ApplicationController
  def index
    @master_configuration = MasterConfiguration.last
  end

  def create
    @master_configuration = MasterConfiguration.new(master_configuration_params)
    if @master_configuration.save
      redirect_to "/master_configurations"
    else
      render "index"
    end
  end

  private

    def master_configuration_params
      params.require(:master_configuration).permit(
        :master_server_host,
        :master_server_docker_host,
        :master_server_username,
        :master_server_port,
        :master_server_password,
        :master_server_jmeter_run_command,
        :influxdb_host,
        :influxdb_port,
        :telegram_credential,
        :telegram_perf_group_id
      )
    end
end
