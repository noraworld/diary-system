class TemplatedArticle < ApplicationRecord
  belongs_to :article, optional: true
end
