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

ActiveRecord::Schema.define(version: 2021_08_27_043403) do

  create_table "ground_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ground_id"
    t.integer "sports_master_id"
    t.index ["ground_id"], name: "index_ground_activities_on_ground_id"
    t.index ["sports_master_id"], name: "index_ground_activities_on_sports_master_id"
  end

  create_table "ground_sports_masters", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ground_id"
    t.integer "sports_master_id"
    t.index ["ground_id"], name: "index_ground_sports_masters_on_ground_id"
    t.index ["sports_master_id"], name: "index_ground_sports_masters_on_sports_master_id"
  end

  create_table "grounds", force: :cascade do |t|
    t.string "ground_name"
    t.integer "ground_pincode"
    t.string "business_email"
    t.integer "business_phone"
    t.float "cost_per_hour"
    t.time "opening_time"
    t.time "closing_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.text "location"
    t.index ["user_id"], name: "index_grounds_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "ground_id"
    t.integer "sports_master_id"
    t.date "date"
    t.integer "starting_time"
    t.integer "finishing_time"
    t.boolean "active"
    t.integer "cost"
    t.index ["ground_id"], name: "index_reservations_on_ground_id"
    t.index ["sports_master_id"], name: "index_reservations_on_sports_master_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "sports_masters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "indoor"
    t.boolean "outdoor"
  end

  create_table "user_activities", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sports_master_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sports_master_id"], name: "index_user_activities_on_sports_master_id"
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "user_sports_masters", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "sports_master_id"
    t.integer "ground_id"
    t.index ["ground_id"], name: "index_user_sports_masters_on_ground_id"
    t.index ["sports_master_id"], name: "index_user_sports_masters_on_sports_master_id"
    t.index ["user_id"], name: "index_user_sports_masters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.string "password"
    t.integer "pincode"
    t.text "address"
    t.integer "phone"
    t.boolean "ground_owner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
