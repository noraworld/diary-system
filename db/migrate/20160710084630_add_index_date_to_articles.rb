class AddIndexDateToArticles < ActiveRecord::Migration[4.2]
  def change
    add_index :articles, [:year, :month, :day], :unique => true, :name => 'date_unique'
  end
end
