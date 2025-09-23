class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.references :vendor, null: false, foreign_key: true
      t.string :name, null: false
      t.date :start_date, null: false, index: true
      t.date :expiry_date, null: false, index: true
      t.date :payment_due_date, null: false, index: true
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end

    add_index :services, [ :vendor_id, :name ]
  end
end
