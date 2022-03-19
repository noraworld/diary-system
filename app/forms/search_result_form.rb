# frozen_string_literal: true

# validate search result
# called from Article#search
class SearchResultForm
  include ActiveModel::Model

  QUANTITIES = 10
  attr_accessor :results, :page, :hitcount, :number_of_pages

  validate :validate_search_result

  private

  def validate_search_result
    return unless results.empty?

    if !hitcount.zero? && page > number_of_pages
      errors.add(:results, :page_exceeded, message: 'There are no search results anymore.')
    else
      errors.add(:results, :query_not_match, message: 'No matches for')
    end
  end
end
