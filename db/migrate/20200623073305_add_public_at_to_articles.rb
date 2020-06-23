class AddPublicAtToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :public_in, :integer, null: true
  end
end
