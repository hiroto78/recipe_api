# RecipesValidator
class RecipesValidator
  class << self
    def validate_create(params, context = nil)
      recipe = Domain::Models::Recipe.new(params)
      raise RecipeApi::Validator::Error::ValidationFailed.new(error: recipe.errors) unless recipe.valid?(context)

      recipe
    end

    def validate_fetch(params, context = nil)
      recipe_request = Domain::Models::RecipeRequest.new(params)
      unless recipe_request.valid?(context)
        raise RecipeApi::Validator::Error::ValidationFailed.new(error: recipe_request.errors)
      end

      recipe_request
    end
  end
end
