require 'rails_helper'

RSpec.describe 'RecipeValidator', type: :request do
  prepare_delete_headers

  describe 'DELETE /recipes/{:id}' do
    before do
      @author = create(:author)
      @recipe = create(:recipe, author_id: @author.id)
    end

    def delete_validate_error(field, value, errors)
      if field == :id
        id = value
      else
        id = @recipe.id
        @params[field] = value
      end

      delete "/recipes/#{id}", params: @params.to_json, headers: @headers

      check_validation_failed(errors)
    end

    context 'success' do
      it 'responds successfully with an HTTP 200 status code' do
        delete "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        expect(response).to have_http_status(200)
      end
    end
    context 'validate each params' do
      context 'id' do
        it 'must exist in the database' do
          delete_validate_error :id, 'dummy',
                                error_response(:recipe_not_found, :recipe)
        end
      end
    end
  end
end
