# frozen_string_literal: true

class AddTelegramIdToLoadTest < ActiveRecord::Migration[5.2]
  def change
    add_column :load_tests, :telegram_id, :integer
  end
end
