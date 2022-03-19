class RenameOrderColumnToTemplates < ActiveRecord::Migration[5.2]
  def change
    rename_column :templates, :order, :sort
  end
end
