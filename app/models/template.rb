# frozen_string_literal: true

class Template < ApplicationRecord
  has_many :templated_articles, dependent: :restrict_with_exception

  include TemplateValidator

  validates :uuid,
            presence: true,
            uniqueness: true

  validates :position,
            presence: true,
            uniqueness: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :is_private,
            inclusion: { in: [true, false] }
end
