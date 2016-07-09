class AddDateToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :year, :string
    add_column :articles, :month, :string
    add_column :articles, :day, :string
  end
end
