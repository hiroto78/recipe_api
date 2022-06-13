require 'rails_helper'

RSpec.describe 'RecipeValidator', type: :request do
  prepare_put_headers

  describe 'PUT /recipes/{:id}' do
    before do
      @author = create(:author)
      @recipe = create(:recipe, author_id: @author.id)
      @params = {
        title: 'Hyper Onigiri'
      }
    end

    def put_validate_error(field, value, errors)
      if field == :id
        id = value
      else
        id = @recipe.id
        @params[field] = value
      end

      put "/recipes/#{id}", params: @params.to_json, headers: @headers

      check_validation_failed(errors)
    end

    context 'success' do
      it 'responds successfully with an HTTP 200 status code' do
        put "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        expect(response).to have_http_status(200)
      end
    end

    context 'validate each params' do
      context 'id' do
        it 'must exist in the database' do
          put_validate_error :id, 'dummy',
                             error_response(:recipe_not_found, :recipe)
        end
      end
      context 'title' do
        it 'must be greater than or equal to 1' do
          put_validate_error :title, '', error_response(:not_blank_error, :title)
        end

        it 'must be less than or equal to 100' do
          put_validate_error :title, "#{'a' * 100}a", error_response(:too_long_error, :title, max_value: 100)
        end
      end
      # TODO: implement
    end
  end
end
