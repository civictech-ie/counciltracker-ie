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

ActiveRecord::Schema.define(version: 2018_04_17_221659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amendments", force: :cascade do |t|
    t.bigint "motion_id"
    t.text "body"
    t.text "official_reference", null: false
    t.bigint "proposers_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.text "pdf_url"
    t.text "vote_ruleset", default: "plurality", null: false
    t.text "vote_method", default: "rollcall", null: false
    t.text "vote_result", default: "error", null: false
    t.text "hashed_id"
    t.index ["hashed_id"], name: "index_amendments_on_hashed_id", unique: true
    t.index ["motion_id"], name: "index_amendments_on_motion_id"
    t.index ["official_reference"], name: "index_amendments_on_official_reference", unique: true
    t.index ["position"], name: "index_amendments_on_position"
    t.index ["proposers_ids"], name: "index_amendments_on_proposers_ids"
    t.index ["vote_result"], name: "index_amendments_on_vote_result"
  end

  create_table "attendances", force: :cascade do |t|
    t.string "attendable_type"
    t.bigint "attendable_id"
    t.text "status"
    t.bigint "councillor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendable_type", "attendable_id"], name: "index_attendances_on_attendable_type_and_attendable_id"
    t.index ["councillor_id"], name: "index_attendances_on_councillor_id"
    t.index ["status"], name: "index_attendances_on_status"
  end

  create_table "change_of_affiliations", force: :cascade do |t|
    t.bigint "councillor_id"
    t.bigint "outgoing_party_id"
    t.bigint "incoming_party_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["councillor_id"], name: "index_change_of_affiliations_on_councillor_id"
    t.index ["incoming_party_id"], name: "index_change_of_affiliations_on_incoming_party_id"
    t.index ["outgoing_party_id"], name: "index_change_of_affiliations_on_outgoing_party_id"
  end

  create_table "co_options", force: :cascade do |t|
    t.bigint "outgoing_seat_id"
    t.bigint "incoming_councillor_id"
    t.bigint "incoming_party_id"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["incoming_councillor_id"], name: "index_co_options_on_incoming_councillor_id"
    t.index ["incoming_party_id"], name: "index_co_options_on_incoming_party_id"
    t.index ["outgoing_seat_id"], name: "index_co_options_on_outgoing_seat_id"
  end

  create_table "council_sessions", force: :cascade do |t|
    t.date "commenced_on"
    t.date "concluded_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commenced_on"], name: "index_council_sessions_on_commenced_on"
    t.index ["concluded_on"], name: "index_council_sessions_on_concluded_on"
  end

  create_table "councillors", force: :cascade do |t|
    t.text "given_name"
    t.text "family_name"
    t.text "full_name"
    t.text "gender"
    t.date "born_on"
    t.text "sort_name", null: false
    t.text "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "dcc_id"
    t.text "portrait_file"
    t.index ["born_on"], name: "index_councillors_on_born_on"
    t.index ["dcc_id"], name: "index_councillors_on_dcc_id", unique: true
    t.index ["full_name"], name: "index_councillors_on_full_name"
    t.index ["slug"], name: "index_councillors_on_slug", unique: true
    t.index ["sort_name"], name: "index_councillors_on_sort_name"
  end

  create_table "elections", force: :cascade do |t|
    t.jsonb "parameters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.date "occurred_on"
    t.bigint "council_session_id"
    t.string "eventable_type"
    t.bigint "eventable_id"
    t.bigint "related_seat_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "committed_at"
    t.index ["committed_at"], name: "index_events_on_committed_at"
    t.index ["council_session_id"], name: "index_events_on_council_session_id"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable_type_and_eventable_id"
  end

  create_table "local_electoral_areas", force: :cascade do |t|
    t.text "name"
    t.text "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_local_electoral_areas_on_name", unique: true
    t.index ["slug"], name: "index_local_electoral_areas_on_slug", unique: true
  end

  create_table "media_mentions", force: :cascade do |t|
    t.text "body"
    t.text "url"
    t.text "source"
    t.string "mentionable_type"
    t.bigint "mentionable_id"
    t.date "published_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentionable_type", "mentionable_id"], name: "index_media_mentions_on_mentionable_type_and_mentionable_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.bigint "council_session_id"
    t.text "meeting_type"
    t.date "occurred_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "dcc_id"
    t.text "hashed_id"
    t.index ["council_session_id"], name: "index_meetings_on_council_session_id"
    t.index ["dcc_id"], name: "index_meetings_on_dcc_id", unique: true
    t.index ["hashed_id"], name: "index_meetings_on_hashed_id", unique: true
    t.index ["occurred_on"], name: "index_meetings_on_occurred_on"
  end

  create_table "motions", force: :cascade do |t|
    t.text "official_reference"
    t.text "title"
    t.bigint "local_electoral_area_ids", default: [], array: true
    t.text "executive_recommendation"
    t.bigint "meeting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "proposers_ids", default: [], array: true
    t.text "tags", default: [], array: true
    t.integer "position"
    t.text "pdf_url"
    t.text "agenda_item"
    t.boolean "votable", default: true
    t.text "body"
    t.text "executive_vote"
    t.boolean "interesting"
    t.text "vote_ruleset", default: "plurality", null: false
    t.text "vote_method", default: "rollcall", null: false
    t.text "vote_result", default: "error", null: false
    t.text "hashed_id"
    t.datetime "published_at"
    t.index ["executive_vote"], name: "index_motions_on_executive_vote"
    t.index ["hashed_id"], name: "index_motions_on_hashed_id", unique: true
    t.index ["interesting"], name: "index_motions_on_interesting"
    t.index ["meeting_id"], name: "index_motions_on_meeting_id"
    t.index ["official_reference"], name: "index_motions_on_official_reference", unique: true
    t.index ["position"], name: "index_motions_on_position"
    t.index ["proposers_ids"], name: "index_motions_on_proposers_ids"
    t.index ["published_at"], name: "index_motions_on_published_at"
    t.index ["tags"], name: "index_motions_on_tags"
    t.index ["votable"], name: "index_motions_on_votable"
    t.index ["vote_result"], name: "index_motions_on_vote_result"
  end

  create_table "parties", force: :cascade do |t|
    t.text "name", null: false
    t.text "slug", null: false
    t.text "colour_hex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_parties_on_name", unique: true
    t.index ["slug"], name: "index_parties_on_slug", unique: true
  end

  create_table "seats", force: :cascade do |t|
    t.bigint "council_session_id"
    t.bigint "local_electoral_area_id"
    t.bigint "councillor_id"
    t.bigint "party_id"
    t.date "commenced_on"
    t.date "concluded_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commenced_on"], name: "index_seats_on_commenced_on"
    t.index ["concluded_on"], name: "index_seats_on_concluded_on"
    t.index ["council_session_id"], name: "index_seats_on_council_session_id"
    t.index ["councillor_id"], name: "index_seats_on_councillor_id"
    t.index ["local_electoral_area_id"], name: "index_seats_on_local_electoral_area_id"
    t.index ["party_id"], name: "index_seats_on_party_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "email_address", null: false
    t.text "crypted_password"
    t.text "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.text "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.boolean "admin"
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "votes", force: :cascade do |t|
    t.string "voteable_type"
    t.bigint "voteable_id"
    t.text "status"
    t.bigint "councillor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["councillor_id"], name: "index_votes_on_councillor_id"
    t.index ["status"], name: "index_votes_on_status"
    t.index ["voteable_type", "voteable_id"], name: "index_votes_on_voteable_type_and_voteable_id"
  end

  add_foreign_key "amendments", "motions"
  add_foreign_key "attendances", "councillors"
  add_foreign_key "change_of_affiliations", "parties", column: "incoming_party_id"
  add_foreign_key "change_of_affiliations", "parties", column: "outgoing_party_id"
  add_foreign_key "co_options", "councillors", column: "incoming_councillor_id"
  add_foreign_key "co_options", "parties", column: "incoming_party_id"
  add_foreign_key "co_options", "seats", column: "outgoing_seat_id"
  add_foreign_key "motions", "meetings"
  add_foreign_key "seats", "council_sessions"
  add_foreign_key "seats", "councillors"
  add_foreign_key "seats", "local_electoral_areas"
  add_foreign_key "seats", "parties"
  add_foreign_key "votes", "councillors"
end
