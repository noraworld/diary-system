class AddSampleTypeToSampleArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :sample_articles, :sample_type, :string
  end
end
