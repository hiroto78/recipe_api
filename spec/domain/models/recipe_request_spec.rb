require 'rails_helper'

RSpec.describe Domain::Models::RecipeRequest, type: :model do
  let(:model) { Domain::Models::RecipeRequest }

  context('validation') do
    before do
      @author = create(:author)
      @recipe = create(:recipe, author_id: @author.id)
    end
    let(:valid_params) do
      {
        id: @recipe.id,
        request_unit: 'imperial'
      }
    end

    let(:recipe_request) { model.new(valid_params) }

    it('passes validation for valid params') { expect(recipe_request.valid?(:show)).to be true }

    # rubocop:disable Metrics/AbcSize
    def expect_validation_error(action, field, value, errors, attribute = nil)
      valid_params[field] = value

      expect(recipe_request.valid?(action)).to be false
      expect(recipe_request.errors.errors.map(&:attribute).uniq.size).to eql(1)
      expect(recipe_request.errors.errors[0].attribute).to eql(attribute || field)
      expect(recipe_request.errors.errors.map(&:type)).to contain_exactly(*errors)
    end
    # rubocop:enable Metrics/AbcSize

    def expect_validation_pass(action, field, value)
      valid_params[field] = value

      expect(recipe_request.valid?(action)).to be true
    end

    describe('request_unit') do
      it('fails for dummy request unit') { expect_validation_error(:show, :request_unit, 'dummy', :inclusion) }
      it('passes for nil request unit') { expect_validation_pass(:show, :request_unit, nil) }
    end

    describe('id') do
      it('fails for not existing id') { expect_validation_error(:show, :id, 'a', :recipe_not_found, :recipe) }
      it('passes for proper id') { expect_validation_pass(:show, :id, @recipe.id) }
    end
    # TODO: implement
  end
end
