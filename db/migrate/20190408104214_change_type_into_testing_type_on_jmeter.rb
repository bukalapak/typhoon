# frozen_string_literal: true

class ChangeTypeIntoTestingTypeOnJmeter < ActiveRecord::Migration[5.2]
  def change
    rename_column :jmeters, :type, :testing_type
  end
end
