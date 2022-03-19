class RemoveSampleArticles < ActiveRecord::Migration[5.2]
  def change
    drop_table :sample_articles do |t|
      t.text "text"
      t.integer "year"
      t.integer "month"
      t.integer "day"
      t.date "date"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "kind"
      t.index ["year", "month", "day"], name: "sample_articles_date_unique", unique: true
    end
  end
end
