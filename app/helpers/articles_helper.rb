# frozen_string_literal: true

module ArticlesHelper
  def adjusted_current_time
    if Setting.last
      Time.now.in_time_zone(ENV.fetch('TIME_ZONE')) - Setting.last.next_day_adjustment_hour.hours
    else
      Time.now.in_time_zone(ENV.fetch('TIME_ZONE'))
    end
  end

  def adjusted_time_difference
    if Setting.last
      Setting.last.next_day_adjustment_hour
    else
      0
    end
  end
end
