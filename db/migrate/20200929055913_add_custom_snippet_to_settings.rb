class AddCustomSnippetToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :custom_snippet, :string, null: true
  end
end
