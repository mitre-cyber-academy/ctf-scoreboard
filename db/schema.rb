# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_16_193117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenge_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "challenge_id"
    t.index ["category_id"], name: "index_challenge_categories_on_category_id"
    t.index ["challenge_id"], name: "index_challenge_categories_on_challenge_id"
  end

  create_table "challenges", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "point_value"
    t.string "achievement_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0, null: false
    t.integer "defense_period", default: 1
    t.integer "defense_points", default: 0
    t.integer "unsolved_increment_period", default: 1
    t.integer "unsolved_increment_points", default: 0
    t.integer "initial_shares", default: 1
    t.integer "solved_decrement_shares", default: 0
    t.integer "first_capture_point_bonus", default: 0
    t.string "type"
    t.integer "solved_decrement_period", default: 1
    t.boolean "design_phase", default: false
    t.bigint "game_id"
    t.boolean "sponsored", default: false, null: false
    t.text "sponsor", default: ''
    t.text "sponsor_logo", default: '', null: false
    t.text "sponsor_description", default: '', null: false
    t.index ["game_id"], name: "index_challenges_on_game_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "divisions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "game_id"
    t.integer "min_year_in_school", default: 0
    t.integer "max_year_in_school", default: 16
  end

  create_table "feed_items", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.integer "division_id"
    t.string "text"
    t.integer "challenge_id"
    t.integer "point_value"
    t.integer "flag_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flags", id: :serial, force: :cascade do |t|
    t.integer "challenge_id"
    t.string "flag"
    t.string "api_url"
    t.string "video_url"
    t.bigint "team_id"
    t.integer "challenge_state", default: 0, null: false
    t.datetime "start_calculation_at"
    t.string "type"
    t.boolean "design_phase", default: false
    t.index ["design_phase"], name: "index_flags_on_design_phase"
    t.index ["team_id"], name: "index_flags_on_team_id"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "start"
    t.datetime "stop"
    t.text "description"
    t.text "terms_of_service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization"
    t.string "contact_url"
    t.text "footer"
    t.integer "team_size", default: 5
    t.string "contact_email"
    t.string "open_source_url"
    t.boolean "prizes_available", default: false
    t.text "recruitment_text"
    t.boolean "enable_completion_certificates", default: false
    t.oid "completion_certificate_template"
    t.text "prizes_text"
    t.text "terms_and_conditions"
    t.integer "board_layout", default: 0, null: false
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.text "text"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_message", default: false
  end

  create_table "models", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "User"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_models_on_email", unique: true
    t.index ["reset_password_token"], name: "index_models_on_reset_password_token", unique: true
  end

  create_table "rails_admin_histories", id: :serial, force: :cascade do |t|
    t.text "message"
    t.string "username"
    t.integer "item"
    t.string "table"
    t.integer "month", limit: 2
    t.bigint "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories"
  end

  create_table "submitted_flags", id: :serial, force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "user_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "flag_id"
    t.string "type"
    t.index ["flag_id"], name: "index_submitted_flags_on_flag_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "team_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "affiliation"
    t.integer "team_captain_id"
    t.integer "division_id"
    t.boolean "eligible", default: false
    t.integer "slots_available", default: 0
    t.index "lower((team_name)::text)", name: "index_teams_on_team_name_unique", unique: true
    t.index ["division_id"], name: "index_teams_on_division_id"
    t.index ["team_captain_id"], name: "index_teams_on_team_captain_id"
  end

  create_table "user_invites", id: :serial, force: :cascade do |t|
    t.string "email"
    t.integer "team_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["team_id"], name: "index_user_invites_on_team_id"
    t.index ["user_id"], name: "index_user_invites_on_user_id"
  end

  create_table "user_requests", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["team_id"], name: "index_user_requests_on_team_id"
    t.index ["user_id"], name: "index_user_requests_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "team_id"
    t.string "full_name"
    t.string "affiliation"
    t.integer "year_in_school", limit: 2
    t.integer "age", limit: 2
    t.string "area_of_study"
    t.string "location"
    t.string "personal_email"
    t.string "state", limit: 2
    t.boolean "compete_for_prizes", default: false
    t.boolean "admin", default: false
    t.float "latitude"
    t.float "longitude"
    t.string "country"
    t.datetime "messages_stamp", default: "1970-01-01 00:00:00", null: false
    t.boolean "interested_in_employment", default: false
    t.oid "resume"
    t.oid "transcript"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  create_table "version_associations", id: :serial, force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "challenge_categories", "categories"
  add_foreign_key "challenge_categories", "challenges"
  add_foreign_key "challenges", "games"
  add_foreign_key "flags", "teams"
  add_foreign_key "submitted_flags", "flags"
  add_foreign_key "teams", "divisions"
end
