class AddIsPrivateToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :is_private, :boolean, default: false, null: false
  end
end
