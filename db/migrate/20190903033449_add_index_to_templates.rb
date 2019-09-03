class AddIndexToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_index :templates, :position, unique: true, name: 'templates_position_unique'
  end
end
