class AddIsPrivateToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :templated_articles, :is_private, :boolean, default: false, null: false
  end
end
