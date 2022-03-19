class AddNextDayAdjustmentHour < ActiveRecord::Migration[5.2]
  def change
    add_column :settings, :next_day_adjustment_hour, :integer, null: false, default: 0
  end
end
