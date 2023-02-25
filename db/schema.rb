# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_25_162434) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "itinerary_id", null: false
    t.bigint "place_id", null: false
    t.string "start_time"
    t.string "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_number"
    t.index ["itinerary_id"], name: "index_events_on_itinerary_id"
    t.index ["place_id"], name: "index_events_on_place_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "itinerary_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_groups_on_itinerary_id"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "itineraries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "start_time"
    t.string "start_address"
    t.string "user_rating"
    t.string "vote"
    t.string "date"
    t.string "budget"
    t.string "interests"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_itineraries_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "details_formatted_address"
    t.string "search_types"
    t.string "search_rating"
    t.string "search_user_ratings_total"
    t.string "search_photo_reference"
    t.string "search_place_deteails_id"
    t.string "details_overview"
    t.string "details_formatted_phone_number"
    t.string "details_opening_hours_periods"
    t.string "search_price_level"
    t.string "details_reviews"
    t.string "details_website"
    t.string "details_wheelchair_accessible_entrance"
    t.string "details_url"
    t.string "search_geometry_location"
    t.string "details_serves_vegeterian_food"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "events", "itineraries"
  add_foreign_key "events", "places"
  add_foreign_key "groups", "itineraries"
  add_foreign_key "groups", "users"
  add_foreign_key "itineraries", "users"
end
