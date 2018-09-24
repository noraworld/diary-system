class AddDatingToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :date, :date, :null => true
  end
end
