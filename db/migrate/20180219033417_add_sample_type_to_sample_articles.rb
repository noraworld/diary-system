class AddSampleTypeToSampleArticles < ActiveRecord::Migration
  def change
    add_column :sample_articles, :sample_type, :string
  end
end
