# frozen_string_literal: true

class AddPasswordSlaveServers < ActiveRecord::Migration[5.2]
  def change
    add_column :slave_servers, :password, :string
  end
end
