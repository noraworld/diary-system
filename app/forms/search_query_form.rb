# frozen_string_literal: true

# validate search query
# called from Article#search
class SearchQueryForm
  include ActiveModel::Model

  MAXIMUM_CHARACTERS = 128
  attr_accessor :q, :page

  validates :q, presence: { message: 'The query string must not be empty.' }
  validates :q, length: { maximum: MAXIMUM_CHARACTERS, message: "The query string is too long. The maximum number of characters is #{MAXIMUM_CHARACTERS}." }

  validates :page, numericality: { only_integer: true, greater_than_or_equal_to: 1, message: 'A positive integer without the plus sign is expected in the page parameter.' }
end
