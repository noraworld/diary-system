class ChangeTextToArticles < ActiveRecord::Migration
  def change
    change_column :articles, :text, :text, null: false
  end
end
