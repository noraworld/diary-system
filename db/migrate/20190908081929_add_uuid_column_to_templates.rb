class AddUuidColumnToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :templates,
               :uuid,
               :string,
               unique: true,
               name: 'templates_uuid_unique'
  end
end
