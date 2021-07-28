class AddColumnSlaveStatusDef < ActiveRecord::Migration[5.2]
  def change
    add_column :slave_servers, :slave_status, :string, default: "ON"
  end
end
