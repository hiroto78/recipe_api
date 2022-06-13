class RecipeSerializer < ActiveModel::Serializer
  attributes :title,
             :description,
             :id,
             :process,
             :ingredient,
             :created_at,
             :updated_at

  belongs_to :author
  class AuthorSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :created_at,
               :updated_at
  end

  has_many :ratings
  class RatingSerializer < ActiveModel::Serializer
    attributes :rate,
               :author_id
  end
end
