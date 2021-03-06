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

ActiveRecord::Schema.define(version: 20170616160002) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "user_ready",   default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "current_step", default: false
    t.integer  "lobby_id"
    t.integer  "team",         default: 1
    t.integer  "lap",          default: 0
    t.boolean  "defeat",       default: false
  end

  create_table "buffs", force: :cascade do |t|
    t.string   "name"
    t.string   "variety"
    t.integer  "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "lobby_id"
    t.string   "variety"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "time"
  end

  create_table "lobbies", force: :cascade do |t|
    t.string   "url"
    t.integer  "count_of_users"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
    t.integer  "game_mode",         default: 3
    t.boolean  "everyone_is_ready", default: false
    t.integer  "lap",               default: 0
    t.boolean  "hidden",            default: false
    t.boolean  "game_over",         default: false
  end

  create_table "units", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "variety"
    t.integer  "hp"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "under_attack"
    t.integer  "lap",          default: 0
    t.boolean  "dead",         default: false
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
