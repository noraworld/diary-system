class ChangeTitleToTemplates < ActiveRecord::Migration[5.2]
  def change
    change_column_null :templates, :title, false
  end
end
