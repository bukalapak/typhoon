# frozen_string_literal: true

class AddTypeTest < ActiveRecord::Migration[5.2]
  def change
    add_column :jmeters, :type, :string
  end
end
