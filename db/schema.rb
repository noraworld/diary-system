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

ActiveRecord::Schema.define(version: 20180219045753) do

  create_table "articles", force: :cascade do |t|
    t.text     "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "year",       null: false
    t.integer  "month",      null: false
    t.integer  "day",        null: false
    t.date     "date",       null: false
  end

  add_index "articles", ["year", "month", "day"], name: "date_unique", unique: true

  create_table "sample_articles", force: :cascade do |t|
    t.text     "text"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "kind"
  end

  add_index "sample_articles", ["year", "month", "day"], name: "sample_articles_date_unique", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
