class RenameSampleTypeColumnToSampleArticles < ActiveRecord::Migration
  def change
    rename_column :sample_articles, :sample_type, :kind
  end
end
