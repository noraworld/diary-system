class ChangeDatingToArticles < ActiveRecord::Migration
  def change
    change_column :articles, :date, :date, :null => false
  end
end
