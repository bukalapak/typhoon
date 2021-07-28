# frozen_string_literal: true

class AddTimeoutToLoadTest < ActiveRecord::Migration[5.2]
  def change
    add_column :load_tests, :timeouts, :integer
  end
end
