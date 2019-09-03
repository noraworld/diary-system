class RenameSortColumnToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    rename_column :templated_articles, :sort, :position
  end
end
