class ChangeTextToArticles < ActiveRecord::Migration[4.2]
  def change
    change_column :articles, :text, :text, null: false
  end
end
