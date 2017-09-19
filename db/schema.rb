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

ActiveRecord::Schema.define(version: 20170915202443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenges", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "point_value"
    t.integer  "category_id"
    t.string   "achievement_name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "state",            default: 0, null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string  "name"
    t.integer "game_id"
    t.integer "min_year_in_school", default: 0
    t.integer "max_year_in_school", default: 16
  end

  create_table "feed_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "division_id"
    t.string   "text"
    t.integer  "challenge_id"
    t.integer  "point_value"
    t.integer  "flag_id"
    t.string   "type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "flags", force: :cascade do |t|
    t.integer "challenge_id"
    t.string  "flag"
    t.string  "api_url"
    t.string  "video_url"
  end

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.datetime "start"
    t.datetime "stop"
    t.text     "description"
    t.text     "terms_of_service"
    t.boolean  "disable_vpn"
    t.boolean  "disable_flags_an_hour_graph", default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.text     "text"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "User"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_models_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_models_on_reset_password_token", unique: true, using: :btree
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.bigint   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree
  end

  create_table "submitted_flags", force: :cascade do |t|
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.string   "text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "team_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "affiliation"
    t.integer  "team_captain_id"
    t.integer  "division_id"
    t.integer  "users_count",     default: 0
    t.boolean  "eligible",        default: false
    t.index ["division_id"], name: "index_teams_on_division_id", using: :btree
    t.index ["team_captain_id"], name: "index_teams_on_team_captain_id", using: :btree
  end

  create_table "user_invites", force: :cascade do |t|
    t.string   "email"
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0, null: false
    t.index ["team_id"], name: "index_user_invites_on_team_id", using: :btree
    t.index ["user_id"], name: "index_user_invites_on_user_id", using: :btree
  end

  create_table "user_requests", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0, null: false
    t.index ["team_id"], name: "index_user_requests_on_team_id", using: :btree
    t.index ["user_id"], name: "index_user_requests_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "",                    null: false
    t.string   "encrypted_password",               default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "team_id"
    t.string   "full_name"
    t.string   "affiliation"
    t.integer  "year_in_school",         limit: 2
    t.string   "gender"
    t.integer  "age",                    limit: 2
    t.string   "area_of_study"
    t.string   "location"
    t.string   "personal_email"
    t.string   "state",                  limit: 2
    t.boolean  "compete_for_prizes",               default: false
    t.boolean  "admin",                            default: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country"
    t.datetime "messages_stamp",                   default: '1970-01-01 00:00:00', null: false
    t.boolean  "vpn_cert_downloaded",              default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["team_id"], name: "index_users_on_team_id", using: :btree
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
    t.index ["version_id"], name: "index_version_associations_on_version_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
    t.index ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree
  end

  add_foreign_key "teams", "divisions"
end
