# frozen_string_literal: true

module ArticlesHelper
  def adjusted_current_time
    Time.now.in_time_zone('Tokyo') - Setting.last.next_day_adjustment_hour.hours
  end
end
