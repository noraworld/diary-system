class AddIsDisabledToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :is_disabled, :boolean, default: false, null: false
  end
end
