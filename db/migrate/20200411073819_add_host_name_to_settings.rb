class AddHostNameToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :host_name, :string, null: true
  end
end
