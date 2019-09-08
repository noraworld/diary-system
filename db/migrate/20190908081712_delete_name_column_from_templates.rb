class DeleteNameColumnFromTemplates < ActiveRecord::Migration[5.2]
  def change
    remove_column :templates, :name
  end
end
