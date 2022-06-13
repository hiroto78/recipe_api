module Domain
  module Models
    class RecipeRequest
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :id
      attribute :request_unit

      validate :recipe_exists?
      validates :request_unit, inclusion: { in: %w[imperial metric] }, unless: -> { request_unit.nil? }, on: :show

      def recipe
        @recipe ||= ::Recipe.by_alive.find_by(id:)
      end

      def recipe_exists?
        errors.add(:recipe, :recipe_not_found, message: 'no recipe found') if recipe.nil?
      end
    end
  end
end
