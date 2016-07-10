class Article < ActiveRecord::Base
  validates :text, presence: true
  validates :year,
    :uniqueness => {:scope => [:month, :day]}
end
