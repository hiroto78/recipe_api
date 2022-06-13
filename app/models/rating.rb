class Rating < ApplicationRecord
  belongs_to :author
  belongs_to :recipe
end
