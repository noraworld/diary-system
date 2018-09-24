class ChangeDatingToArticles < ActiveRecord::Migration[4.2]
  def change
    change_column :articles, :date, :date, :null => false
  end
end
