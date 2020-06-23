class AddDefaultPublicInToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :default_public_in, :integer, null: true
  end
end
