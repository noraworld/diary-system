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
  STAR_RANGE = ('1'..'10').to_a.freeze
  BOOL_RANGE = %w[yes no].freeze

  included do
    validates :title, presence: true
    validates :format, inclusion: { in: FORMAT_TYPES }

    validates :body, inclusion:    { in: STAR_RANGE },                                  if: :star?
    validates :body, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: :duration?
    validates :body, inclusion:    { in: BOOL_RANGE },                                  if: :bool?
    validates :body, length:       { maximum: 32 },                                     if: :oneline?
  end

  def star?
    format == 'star' && body.present?
  end

  def duration?
    format == 'duration' && body.present?
  end

  def bool?
    format == 'bool' && body.present?
  end

  def oneline?
    format == 'oneline' && body.present?
  end
end
