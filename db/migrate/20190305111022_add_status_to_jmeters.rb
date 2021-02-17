# frozen_string_literal: true

class AddStatusToJmeters < ActiveRecord::Migration[5.2]
  def change
    add_column :jmeters, :status, :string
  end
end
