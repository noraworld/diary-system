class AddFormatColumnToTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :templates, :format, :string, null: false, default: 'sentence'
  end
end
