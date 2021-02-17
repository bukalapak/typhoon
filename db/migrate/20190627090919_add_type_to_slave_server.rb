# frozen_string_literal: true

class AddTypeToSlaveServer < ActiveRecord::Migration[5.2]
  def change
    add_column :slave_servers, :slave_type, :string
  end
end
