class RenameGaTrackingIdColumnToSettings < ActiveRecord::Migration[5.2]
  def change
    rename_column :settings, :ga_tracking_id, :ga_tracking_identifier
  end
end
