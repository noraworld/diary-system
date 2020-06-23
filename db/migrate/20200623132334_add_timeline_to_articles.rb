class AddTimelineToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :timeline, :string, null: true
  end
end
