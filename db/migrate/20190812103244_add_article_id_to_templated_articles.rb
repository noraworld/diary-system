class AddArticleIdToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :templated_articles, :article_id, :integer
  end
end
