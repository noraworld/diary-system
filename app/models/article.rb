class Article < ActiveRecord::Base
  validates :year,
    :uniqueness => {:scope => [:month, :day]}
end
