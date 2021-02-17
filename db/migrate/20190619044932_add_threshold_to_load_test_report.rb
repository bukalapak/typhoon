# frozen_string_literal: true

class AddThresholdToLoadTestReport < ActiveRecord::Migration[5.2]
  def change
    add_column :load_test_reports, :threshold, :integer
  end
end
