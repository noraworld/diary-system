class RenameSampleTypeColumnToSampleArticles < ActiveRecord::Migration[4.2]
  def change
    rename_column :sample_articles, :sample_type, :kind
  end
end
