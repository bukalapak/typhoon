# frozen_string_literal: true

class AddPreviousResultToLoadTestReport < ActiveRecord::Migration[5.2]
  def change
    add_column :load_test_reports, :percentile_90_previous, :integer
    add_column :load_test_reports, :percentile_95_previous, :integer
    add_column :load_test_reports, :percentile_99_previous, :integer
  end
end
