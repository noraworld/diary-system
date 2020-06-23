# frozen_string_literal: true

class Setting < ApplicationRecord
  validates :default_public_in,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            allow_nil: true
end
