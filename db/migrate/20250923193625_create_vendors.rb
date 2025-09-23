class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :spoc, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :status, null: false, default: 'active', index: true

      t.timestamps
    end

    add_index :vendors, :email, unique: true
  end
end
