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

ActiveRecord::Schema.define(version: 2020_07_24_220043) do

  create_table "articles", force: :cascade do |t|
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "day", null: false
    t.date "date", null: false
    t.integer "public_in"
    t.string "timeline"
    t.index ["year", "month", "day"], name: "date_unique", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "site_title", null: false
    t.string "site_description"
    t.integer "launched_since"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "host_name"
    t.integer "default_public_in"
    t.string "ga_tracking_identifier"
    t.integer "next_day_adjustment_hour", default: 0, null: false
  end

  create_table "templated_articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "article_id"
    t.integer "template_id"
    t.string "format", default: "sentence", null: false
    t.boolean "is_private", default: false, null: false
    t.string "placeholder"
    t.text "template_body"
    t.index ["position", "article_id"], name: "templated_articles_position_unique", unique: true
  end

  create_table "templates", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.string "format", default: "sentence", null: false
    t.boolean "is_private", default: false, null: false
    t.boolean "is_disabled", default: false, null: false
    t.string "placeholder"
    t.index ["position"], name: "templates_position_unique", unique: true
    t.index ["uuid"], name: "templates_uuid_unique", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
