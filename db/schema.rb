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

ActiveRecord::Schema.define(version: 20141209053904) do

  create_table "feeds", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enable_public_archiving", default: false
  end

  add_index "feeds", ["slug"], name: "index_feeds_on_slug", unique: true
  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id"

  create_table "peers", force: true do |t|
    t.string   "peer_id"
    t.string   "info_hash"
    t.string   "ip"
    t.integer  "port"
    t.integer  "uploaded"
    t.integer  "downloaded"
    t.integer  "left"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "peers", ["info_hash", "state"], name: "index_peers_on_info_hash_and_state"
  add_index "peers", ["ip"], name: "index_peers_on_ip"
  add_index "peers", ["peer_id"], name: "index_peers_on_peer_id"

  create_table "permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["feed_id"], name: "index_permissions_on_feed_id"
  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id"

  create_table "torrents", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "size",            limit: 8
    t.string   "info_hash",                 null: false
    t.binary   "data",                      null: false
    t.integer  "feed_id"
    t.integer  "pieces"
    t.integer  "piece_length"
    t.string   "file_created_by"
  end

  add_index "torrents", ["feed_id"], name: "index_torrents_on_feed_id"
  add_index "torrents", ["info_hash"], name: "index_torrents_on_info_hash", unique: true
  add_index "torrents", ["slug"], name: "index_torrents_on_slug", unique: true
  add_index "torrents", ["user_id"], name: "index_torrents_on_user_id"

  create_table "users", force: true do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "name",                   default: "",    null: false
    t.string   "authentication_token"
    t.boolean  "approved"
  end

  add_index "users", ["approved"], name: "index_users_on_approved"
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end
