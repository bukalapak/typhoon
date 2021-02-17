# frozen_string_literal: true

class CreateLoadTestReports < ActiveRecord::Migration[5.2]
  def change
    create_table :load_test_reports do |t|
      t.integer :load_test_id
      t.integer :jmeter_id
      t.string  :label
      t.integer :samples
      t.integer :average
      t.integer :percentile_90
      t.integer :percentile_95
      t.integer :percentile_99
      t.integer :min
      t.integer :max
      t.integer :error_rate

      t.timestamps
    end
    add_index :load_test_reports, [:load_test_id, :jmeter_id]
  end
end
