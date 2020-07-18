class DeleteTimeZoneFromSettings < ActiveRecord::Migration[5.2]
  def up
    remove_column :settings, :time_zone
  end

  def down
    add_column :settings, :time_zone, :string, null: false, default: 'UTC'
  end
end
