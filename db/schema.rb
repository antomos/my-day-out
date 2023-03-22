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

ActiveRecord::Schema[7.0].define(version: 2023_03_21_183115) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "check_open_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "create_user_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.bigint "itinerary_id", null: false
    t.bigint "place_id", null: false
    t.string "start_time"
    t.string "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_number"
    t.jsonb "alternative_places", default: {}
    t.jsonb "directions_to_event", default: {}
    t.integer "event_duration"
    t.boolean "removed", default: false
    t.boolean "open_now"
    t.integer "delay", default: 0
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
    t.string "start_address"
    t.string "user_rating"
    t.string "vote"
    t.string "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dining_requirements"
    t.time "start_time"
    t.time "end_time"
    t.date "date"
    t.text "interests", default: [], array: true
    t.float "latitude"
    t.float "longitude"
    t.boolean "saved", default: false
    t.string "share_token"
    t.index ["share_token"], name: "index_itineraries_on_share_token"
    t.index ["user_id"], name: "index_itineraries_on_user_id"
  end

  create_table "itinerary_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.string "details_formatted_address"
    t.string "search_types"
    t.integer "search_rating"
    t.integer "search_user_ratings_total"
    t.string "search_photo_reference"
    t.string "search_place_details_id"
    t.string "details_overview"
    t.string "details_formatted_phone_number"
    t.integer "search_price_level"
    t.text "details_reviews", default: [], array: true
    t.string "details_website"
    t.boolean "details_wheelchair_accessible_entrance"
    t.string "details_url"
    t.string "search_geometry_location"
    t.boolean "details_serves_vegetarian_food"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.jsonb "details_opening_hours_periods", default: {}
  end

  create_table "populate_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "populate_itineraries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "populate_places", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_place_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "set_travel_times", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "address"
    t.integer "duration"
    t.string "image_url"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "events", "itineraries"
  add_foreign_key "events", "places"
  add_foreign_key "groups", "itineraries"
  add_foreign_key "groups", "users"
  add_foreign_key "itineraries", "users"
end
