class AddTimeZoneToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :time_zone, :string, null: false, default: 'UTC'
  end
end
