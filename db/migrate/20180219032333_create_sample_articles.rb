class CreateSampleArticles < ActiveRecord::Migration
  def change
    create_table :sample_articles do |t|
      t.text :text
      t.integer :year
      t.integer :month
      t.integer :day
      t.date :date

      t.timestamps null: false
    end
  end
end
