class RecipesController < ApplicationController
  before_action :validate_create_recipe, only: %i[create update]
  before_action :validate_fetch_recipe, only: %i[show destroy]
  before_action :set_recipe, only: %i[show update destroy]

  def show
    @recipe.ingredient = @recipe.specified_ingredient(@req_params.request_unit)
    render json: @recipe, serializer: RecipeSerializer
  end

  def create
    @recipe = Recipe.new(@domain_recipe.hash_for_create)
    if @recipe.save
      @recipe.ingredient = @recipe.specified_ingredient(@domain_recipe.request_unit)
      render json: @recipe, serializer: RecipeSerializer, status: :created
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def update
    if @recipe.update(@domain_recipe.hash_for_update)
      @recipe.ingredient = @recipe.specified_ingredient(@domain_recipe.request_unit)
      render json: @recipe, serializer: RecipeSerializer, status: :ok
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def destroy
    params = { deleted_at: Time.now }
    if @recipe.update(params)
      render json: { id: @recipe.id }, status: :ok
    else
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def validate_create_recipe
    @domain_recipe = RecipesValidator.validate_create(
      params.permit(
        *Domain::Models::Recipe.attribute_names,
        ingredient: Domain::Models::Ingredient::INGREDIENT.to_a
      ),
      action_name.to_sym
    )
  end

  def validate_fetch_recipe
    @req_params = RecipesValidator.validate_fetch(
      params.permit(
        *Domain::Models::RecipeRequest.attribute_names
      ),
      action_name.to_sym
    )
  end

  def set_recipe
    @recipe = if @domain_recipe.nil?
                Recipe.find(@req_params.id)
              else
                Recipe.find(@domain_recipe.id)
              end
  end
end
