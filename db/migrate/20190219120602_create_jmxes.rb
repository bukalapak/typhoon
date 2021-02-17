# frozen_string_literal: true

class CreateJmxes < ActiveRecord::Migration[5.2]
  def change
    create_table :jmxes do |t|
      t.string :name

      t.timestamps
    end
  end
end
