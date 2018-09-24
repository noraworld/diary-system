class ChangeDateToArticles < ActiveRecord::Migration[4.2]
  def change
    change_column :articles, :year, :integer, null: false
    change_column :articles, :month, :integer, null: false
    change_column :articles, :day, :integer, null: false
  end
end
