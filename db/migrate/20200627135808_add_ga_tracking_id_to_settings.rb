class AddGaTrackingIdToSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :ga_tracking_id, :string, null: true
  end
end
