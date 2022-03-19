class AddPlaceholderToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :templated_articles, :placeholder, :string, null: true
  end
end
