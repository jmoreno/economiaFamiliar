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

ActiveRecord::Schema.define(version: 20170115191149) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "reference"
    t.decimal  "first_balance"
    t.index ["name"], name: "index_accounts_on_name"
  end

  create_table "activities", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "account_id"
    t.integer  "origin_id"
    t.string   "name"
    t.date     "operationDate"
    t.date     "valueDate"
    t.decimal  "amount"
    t.decimal  "balance"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "card"
    t.string   "concept"
    t.decimal  "commission"
    t.string   "reference"
    t.string   "command"
    t.index ["account_id"], name: "index_activities_on_account_id"
    t.index ["category_id"], name: "index_activities_on_category_id"
    t.index ["origin_id"], name: "index_activities_on_origin_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "category_regexes", force: :cascade do |t|
    t.string   "regex"
    t.string   "category_name"
    t.integer  "origin"
    t.integer  "card"
    t.integer  "reference"
    t.integer  "concept"
    t.integer  "command"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "origins", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_origins_on_name"
  end

  create_table "patterns", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.integer  "frequency"
    t.date     "last_activity"
    t.date     "next_activity"
    t.decimal  "last_amount"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["category_id"], name: "index_patterns_on_category_id"
  end

  create_table "patterns_origins", id: false, force: :cascade do |t|
    t.integer "pattern_id"
    t.integer "ogiring_id"
    t.index ["ogiring_id"], name: "index_patterns_origins_on_ogiring_id"
    t.index ["pattern_id"], name: "index_patterns_origins_on_pattern_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
