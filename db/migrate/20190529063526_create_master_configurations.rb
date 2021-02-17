# frozen_string_literal: true

class CreateMasterConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :master_configurations do |t|
      t.string :master_server_host
      t.string :master_server_docker_host
      t.string :master_server_username
      t.integer :master_server_port
      t.string :master_server_password
      t.string :master_server_jmeter_run_command
      t.string :influxdb_host
      t.integer :influxdb_port
      t.string :telegram_credential
      t.string :telegram_perf_group_id

      t.timestamps
    end
  end
end
