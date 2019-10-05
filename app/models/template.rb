class Template < ApplicationRecord

  FORMAT_TYPES = %w[
    sentence
    star
    duration
    bool
    oneline
  ]

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

  validates :format,
            inclusion: { in: FORMAT_TYPES }
end
