# frozen_string_literal: true

class MigrateForm
  include ActiveModel::Model

  attr_accessor :from, :to

  validates :from, presence: { message: 'The origin date ("from" parameter) is missing.' }
  validates :from, format: { with: /\A[0-9]{4}-[0-9]{2}-[0-9]{2}\z/, message: 'The "from" parameter is out of range of date type' }

  validates :to, presence: { message: 'The destination date ("to" parameter) is missing.' }
  validates :to, format: { with: /\A[0-9]{4}-[0-9]{2}-[0-9]{2}\z/, message: 'The "to" parameter is out of range of date type' }

  validate :check_origin_existence
  validate :check_destination_existence

  private

  def check_origin_existence
    return if from.blank?

    year_from, month_from, day_from = from.split('-').map(&:to_i)
    errors.add(:from, message: 'The diary not found in the origin date.') if Article.find_by(date: Date.new(year_from, month_from, day_from)).blank?
  end

  def check_destination_existence
    return if to.blank?

    year_to, month_to, day_to = to.split('-').map(&:to_i)
    errors.add(:to, message: 'The diary already exists in the destination date.') if Article.find_by(date: Date.new(year_to, month_to, day_to)).present?
  end
end
