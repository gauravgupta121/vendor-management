class AddStatusToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :status, :string, default: 'active'
    add_index :services, :status
  end
end
