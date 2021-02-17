# frozen_string_literal: true

class AddTimeoutsToJmeters < ActiveRecord::Migration[5.2]
  def change
    add_column :jmeters, :timeouts, :integer
  end
end
