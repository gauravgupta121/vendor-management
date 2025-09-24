# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_24_030000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "services", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "expiry_date", null: false
    t.date "payment_due_date", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.index ["expiry_date"], name: "index_services_on_expiry_date"
    t.index ["payment_due_date"], name: "index_services_on_payment_due_date"
    t.index ["start_date"], name: "index_services_on_start_date"
    t.index ["status"], name: "index_services_on_status"
    t.index ["vendor_id", "name"], name: "index_services_on_vendor_id_and_name"
    t.index ["vendor_id"], name: "index_services_on_vendor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name", null: false
    t.string "spoc", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_vendors_on_email", unique: true
    t.index ["status"], name: "index_vendors_on_status"
  end

  add_foreign_key "services", "vendors"
end
