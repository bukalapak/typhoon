# frozen_string_literal: true

class ChangeTelegramIdToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :load_tests, :telegram_id, :bigint
    change_column :master_configurations, :telegram_perf_group_id, :bigint
  end
end
