class AddPlaceholderToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :placeholder, :string, null: true
  end
end
