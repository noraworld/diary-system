class Template < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  validates :title,
            presence: true

  validates :sort,
            presence: true,
            uniqueness: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1
            }
end
