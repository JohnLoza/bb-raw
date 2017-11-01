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

ActiveRecord::Schema.define(version: 20171101155953) do

  create_table "providers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hash_id", null: false, collation: "utf8_bin"
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "contact"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hash_id"], name: "index_providers_on_hash_id", unique: true
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
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["hash_id"], name: "index_users_on_hash_id", unique: true
  end

end
