class AddIndexToSampleArticles < ActiveRecord::Migration[4.2]
  def change
    add_index :sample_articles, [:year, :month, :day], name: "sample_articles_date_unique", unique: true
  end
end
