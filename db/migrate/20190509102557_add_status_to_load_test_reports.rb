# frozen_string_literal: true

class AddStatusToLoadTestReports < ActiveRecord::Migration[5.2]
  def change
    add_column :load_test_reports, :status, :string
  end
end
