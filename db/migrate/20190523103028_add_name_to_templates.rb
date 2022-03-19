class AddNameToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column    :templates, :name, :string
    change_column :templates, :name, :string, null: false
  end
end
