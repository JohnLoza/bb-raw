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

ActiveRecord::Schema.define(version: 20171116165551) do

  create_table "development_order_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "development_order_id"
    t.bigint "product_category_id"
    t.decimal "bulk", precision: 10, scale: 2
    t.index ["development_order_id"], name: "index_development_order_products_on_development_order_id"
    t.index ["product_category_id"], name: "index_development_order_products_on_product_category_id"
  end

  create_table "development_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "user_id"
    t.string "description"
    t.date "required_date"
    t.datetime "supplied_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_development_orders_on_deleted_at"
    t.index ["hash_id"], name: "index_development_orders_on_hash_id", unique: true
    t.index ["user_id"], name: "index_development_orders_on_user_id"
  end

  create_table "entry_product_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "entry_product_report_id"
    t.bigint "provider_product_id"
    t.string "batch"
    t.date "expiration_date"
    t.string "invoice_folio"
    t.date "invoice_date"
    t.decimal "tare", precision: 10, scale: 2
    t.decimal "bulk", precision: 10, scale: 2
    t.index ["entry_product_report_id"], name: "index_entry_product_details_on_entry_product_report_id"
    t.index ["provider_product_id"], name: "index_entry_product_details_on_provider_product_id"
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
    t.index ["user_id"], name: "index_entry_product_reports_on_user_id"
  end

  create_table "product_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "product_category_id"
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_product_categories_on_deleted_at"
    t.index ["hash_id"], name: "index_product_categories_on_hash_id", unique: true
    t.index ["product_category_id"], name: "index_product_categories_on_product_category_id"
  end

  create_table "provider_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.bigint "provider_id"
    t.bigint "product_category_id"
    t.string "name"
    t.string "presentation"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_provider_products_on_deleted_at"
    t.index ["hash_id"], name: "index_provider_products_on_hash_id", unique: true
    t.index ["product_category_id"], name: "index_provider_products_on_product_category_id"
    t.index ["provider_id"], name: "index_provider_products_on_provider_id"
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
    t.bigint "provider_product_id"
    t.string "batch"
    t.date "expiration_date"
    t.string "invoice_folio"
    t.date "invoice_date"
    t.decimal "bulk", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_product_id"], name: "index_stocks_on_provider_product_id"
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

  add_foreign_key "entry_product_details", "entry_product_reports"
  add_foreign_key "entry_product_details", "provider_products"
  add_foreign_key "entry_product_reports", "users"
  add_foreign_key "entry_product_reports", "users", column: "authorizer_id"
  add_foreign_key "product_categories", "product_categories"
  add_foreign_key "stocks", "provider_products"
end
