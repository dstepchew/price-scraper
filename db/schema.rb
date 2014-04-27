# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140427170718) do

  create_table "pins", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "web_address"
    t.text     "url"
    t.integer  "product_id"
    t.integer  "store_id"
  end

  add_index "pins", ["url"], name: "index_pins_on_url"
  add_index "pins", ["user_id"], name: "index_pins_on_user_id"
  add_index "pins", ["web_address"], name: "index_pins_on_web_address"

  create_table "product_price_updates", force: true do |t|
    t.integer  "pin_id"
    t.decimal  "previous_price"
    t.decimal  "updated_price"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "imageurl"
    t.text     "url"
    t.decimal  "price",       precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id"
    t.string   "status",                              default: "Active"
  end

  add_index "products", ["store_id"], name: "index_products_on_Store_id"

  create_table "selector_exceptions", force: true do |t|
    t.integer  "store_id"
    t.text     "message"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.text     "backtrace"
    t.integer  "user_id"
  end

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_selector"
    t.string   "price_selector"
    t.string   "image_selector"
    t.string   "product_selector"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_remote_url"
    t.string   "salepriceselector"
    t.boolean  "image_uses_relative_path"
    t.boolean  "sales_price_selector",       limit: 255
    t.string   "price_selector_2"
    t.string   "status",                                 default: "Active"
    t.boolean  "image_uses_relative_path_2"
    t.string   "affiliate_code",                         default: " "
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "username"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
