# frozen_string_literal: true

class Template < ApplicationRecord
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
end
