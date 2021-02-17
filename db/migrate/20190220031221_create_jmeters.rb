# frozen_string_literal: true

class CreateJmeters < ActiveRecord::Migration[5.2]
  def change
    create_table :jmeters do |t|
      t.integer :jmx_id
      t.string :jmx_name
      t.integer :threads
      t.integer :ramp
      t.integer :duration

      t.timestamps
    end
  end
end
