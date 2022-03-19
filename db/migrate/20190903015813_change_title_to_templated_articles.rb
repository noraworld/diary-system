class ChangeTitleToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    change_column_null :templated_articles, :title, false
  end
end
