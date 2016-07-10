class AddIndexDateToArticles < ActiveRecord::Migration
  def change
    add_index :articles, [:year, :month, :day], :unique => true, :name => 'date_unique'
  end
end
