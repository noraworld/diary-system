# frozen_string_literal: true

class Setting < ApplicationRecord
  validates :default_public_in,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_nil: true

  validates :ga_tracking_identifier,
            format: {
              with: /\AUA-[0-9]{9}-[0-9]{1}\z/,
              message: 'Tracking ID is invalid'
            },
            allow_blank: true
end
