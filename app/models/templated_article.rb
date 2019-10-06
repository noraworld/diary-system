# frozen_string_literal: true

class TemplatedArticle < ApplicationRecord
  belongs_to :article, optional: true
  belongs_to :template

  include TemplateValidator
end
