# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180109154820) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "category_id"
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_on_category_id"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
    t.index ["hash_id"], name: "index_categories_on_hash_id", unique: true
  end

  create_table "development_order_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "development_order_id"
    t.string "product"
    t.decimal "bulk", precision: 10, scale: 2
    t.index ["development_order_id"], name: "index_development_order_products_on_development_order_id"
  end

  create_table "development_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "user_id"
    t.string "description"
    t.date "required_date"
    t.bigint "supplier_id"
    t.datetime "supplied_at"
    t.bigint "supplies_authorizer_id"
    t.datetime "supplies_authorized_at"
    t.datetime "formulation_processes_finished_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_development_orders_on_deleted_at"
    t.index ["hash_id"], name: "index_development_orders_on_hash_id", unique: true
    t.index ["supplier_id"], name: "index_development_orders_on_supplier_id"
    t.index ["supplies_authorizer_id"], name: "index_development_orders_on_supplies_authorizer_id"
    t.index ["user_id"], name: "index_development_orders_on_user_id"
  end

  create_table "entry_product_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "entry_product_report_id"
    t.bigint "product_id"
    t.string "batch"
    t.date "expiration_date"
    t.string "invoice_folio"
    t.date "invoice_date"
    t.decimal "tare", precision: 10, scale: 2
    t.decimal "bulk", precision: 10, scale: 2
    t.index ["entry_product_report_id"], name: "index_entry_product_details_on_entry_product_report_id"
    t.index ["product_id"], name: "index_entry_product_details_on_product_id"
  end

  create_table "entry_product_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "user_id"
    t.bigint "authorizer_id"
    t.datetime "authorized_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorizer_id"], name: "index_entry_product_reports_on_authorizer_id"
    t.index ["deleted_at"], name: "index_entry_product_reports_on_deleted_at"
    t.index ["hash_id"], name: "index_entry_product_reports_on_hash_id", unique: true
    t.index ["user_id"], name: "index_entry_product_reports_on_user_id"
  end

  create_table "formulation_processes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "user_id"
    t.bigint "development_order_id"
    t.string "product_name"
    t.string "batch"
    t.string "net_amount"
    t.string "number_of_cuvettes"
    t.date "prorated_expiration_date"
    t.date "gustatory_expiration_date"
    t.date "microbial_expiration_date"
    t.string "product_life"
    t.text "equipment_used"
    t.string "homogeneization_time"
    t.string "temperature"
    t.string "total_formulation_time"
    t.text "comment"
    t.datetime "presentation_assigned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["development_order_id"], name: "index_formulation_processes_on_development_order_id"
    t.index ["hash_id"], name: "index_formulation_processes_on_hash_id", unique: true
    t.index ["user_id"], name: "index_formulation_processes_on_user_id"
  end

  create_table "production_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "user_id"
    t.bigint "formulation_process_id"
    t.string "net_amount"
    t.string "product_presentation"
    t.string "packing_type"
    t.string "total_packages"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulation_process_id"], name: "index_production_orders_on_formulation_process_id"
    t.index ["hash_id"], name: "index_production_orders_on_hash_id", unique: true
    t.index ["user_id"], name: "index_production_orders_on_user_id"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "provider_id"
    t.string "name"
    t.string "presentation"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["hash_id"], name: "index_products_on_hash_id", unique: true
    t.index ["provider_id"], name: "index_products_on_provider_id"
  end

  create_table "providers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "contact"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_providers_on_deleted_at"
    t.index ["hash_id"], name: "index_providers_on_hash_id", unique: true
  end

  create_table "stocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "product_id"
    t.string "batch"
    t.date "expiration_date"
    t.string "invoice_folio"
    t.date "invoice_date"
    t.decimal "bulk", precision: 10, scale: 2
    t.decimal "original_bulk", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_stocks_on_product_id"
  end

  create_table "supplies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "development_order_id"
    t.bigint "stock_id"
    t.decimal "bulk", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["development_order_id"], name: "index_supplies_on_development_order_id"
    t.index ["stock_id"], name: "index_supplies_on_stock_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.string "email"
    t.string "name"
    t.string "username"
    t.string "address"
    t.string "phone_number"
    t.string "cell_phone_number"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "roles"
    t.string "avatar"
    t.boolean "is_admin", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["hash_id"], name: "index_users_on_hash_id", unique: true
  end

  add_foreign_key "categories", "categories"
  add_foreign_key "development_orders", "users", column: "supplier_id"
  add_foreign_key "development_orders", "users", column: "supplies_authorizer_id"
  add_foreign_key "entry_product_details", "entry_product_reports"
  add_foreign_key "entry_product_details", "products"
  add_foreign_key "entry_product_reports", "users"
  add_foreign_key "entry_product_reports", "users", column: "authorizer_id"
  add_foreign_key "formulation_processes", "development_orders"
  add_foreign_key "stocks", "products"
end
