class AddDatingToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :date, :date, :null => true
  end
end
