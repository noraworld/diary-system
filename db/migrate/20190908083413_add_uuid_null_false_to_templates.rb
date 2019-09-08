class AddUuidNullFalseToTemplates < ActiveRecord::Migration[5.2]
  def change
    change_column :templates,
                  :uuid,
                  :string,
                  null: false
  end
end
