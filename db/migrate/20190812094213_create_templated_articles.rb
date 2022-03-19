class CreateTemplatedArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :templated_articles do |t|
      t.string :title
      t.text :body
      t.integer :sort, null: false, unique: true

      t.timestamps
    end
  end
end
