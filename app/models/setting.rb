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

  validates :ga_tracking_identifier,
            format: {
              with: /\AUA-[0-9]{9}-[0-9]{1}\z/,
              message: 'Tracking ID is invalid'
            },
            allow_blank: true
end
