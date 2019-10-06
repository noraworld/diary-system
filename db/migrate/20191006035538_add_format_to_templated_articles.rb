class AddFormatToTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :templated_articles, :format, :string, null: false, default: 'sentence'
  end
end
