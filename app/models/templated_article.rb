# frozen_string_literal: true

class TemplatedArticle < ApplicationRecord
  belongs_to :article, optional: true
end
