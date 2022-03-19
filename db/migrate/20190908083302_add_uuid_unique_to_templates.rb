class AddUuidUniqueToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_index :templates,
              :uuid,
              unique: true,
              name: 'templates_uuid_unique'
  end
end
