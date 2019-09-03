class RenameSortColumnToTemplates < ActiveRecord::Migration[5.2]
  def change
    rename_column :templates, :sort, :position
  end
end
