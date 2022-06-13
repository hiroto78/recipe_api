class Author < ApplicationRecord
  has_many :recipe
  has_many :rating
end
