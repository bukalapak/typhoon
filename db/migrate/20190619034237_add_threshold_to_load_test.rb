# frozen_string_literal: true

class AddThresholdToLoadTest < ActiveRecord::Migration[5.2]
  def change
    add_column :load_tests, :threshold, :integer
  end
end
