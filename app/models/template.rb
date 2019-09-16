class Template < ApplicationRecord
  validates :uuid,
            presence: true,
            uniqueness: true

  validates :title,
            presence: true

  validates :position,
            presence: true,
            uniqueness: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
end
