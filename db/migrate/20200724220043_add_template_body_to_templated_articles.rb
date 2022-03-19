class AddTemplateBodyToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :templated_articles, :template_body, :text, null: true
  end
end
