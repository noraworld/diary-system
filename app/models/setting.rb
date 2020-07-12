# frozen_string_literal: true

class Setting < ApplicationRecord
  validates :default_public_in,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  validates :next_day_adjustment_hour,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 23,
              message: 'should be greater than or equal to 0 and less than or equal to 23'
            },
            allow_nil: false

  validates :time_zone,
            inclusion: {
              # https://moreta.github.io/ruby/rails/ruby-rails-time-date-timezone.html#%E6%9C%89%E5%8A%B9%E3%81%AAtimezone%E4%B8%80%E8%A6%A7
              # https://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html
              in: TZInfo::Timezone.all.map(&:name),
              message: 'is out of range of time zone'
            },
            allow_nil: false

  validates :ga_tracking_identifier,
            format: {
              with: /\AUA-[0-9]{9}-[0-9]{1}\z/,
              message: 'Tracking ID is invalid'
            },
            allow_blank: true
end
