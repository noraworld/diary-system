class AddIndexToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    add_index :templated_articles, [:position, :article_id], unique: true, name: 'templated_articles_position_unique'
  end
end
