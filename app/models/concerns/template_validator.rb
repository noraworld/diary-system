# frozen_string_literal: true

module TemplateValidator
  extend ActiveSupport::Concern

  FORMAT_TYPES = %w[
    sentence
    star
    duration
    bool
    oneline
  ].freeze

  included do
    validates :title,
              presence: true

    validates :format,
              inclusion: { in: FORMAT_TYPES }
  end
end
