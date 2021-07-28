# frozen_string_literal: true

class CreateSlaveServers < ActiveRecord::Migration[5.2]
  def change
    create_table :slave_servers do |t|
      t.string :host
      t.string :username
      t.integer :port

      t.timestamps
    end
  end
end
