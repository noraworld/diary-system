class AddTemplateIdToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :templated_articles, :template_id, :integer
  end
end
