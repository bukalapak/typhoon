# frozen_string_literal: true

class CreateLoadTests < ActiveRecord::Migration[5.2]
  def change
    create_table :load_tests do |t|
      t.integer :jmx_id
      t.string :jmx_name
      t.integer :threads
      t.integer :ramp
      t.integer :duration
      t.string :squad
      t.text :note
      t.string :status

      t.timestamps
    end
  end
end
