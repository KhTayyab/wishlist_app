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

ActiveRecord::Schema.define(version: 20180330104019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_configurations", force: :cascade do |t|
    t.string   "shop_name"
    t.string   "shop_url"
    t.string   "actual_shop_url"
    t.string   "api_key"
    t.string   "api_password"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "to_email_address", default: ""
    t.string   "cc_email_address", default: ""
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree
  end

  create_table "user_wish_lists", force: :cascade do |t|
    t.string   "customer_id"
    t.string   "product_id"
    t.string   "variant_id"
    t.string   "customer_email"
    t.string   "customer_name"
    t.string   "product_title"
    t.string   "product_sku"
    t.string   "product_image"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "shop_domain"
    t.string   "customer_phone", default: ""
    t.string   "customer_city",  default: ""
    t.datetime "wish_list_date"
    t.boolean  "is_restock",     default: false
    t.string   "variant_title",  default: ""
    t.string   "barcode",        default: ""
  end

end
