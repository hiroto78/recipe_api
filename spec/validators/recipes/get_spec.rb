require 'rails_helper'

RSpec.describe 'RecipeValidator', type: :request do
  prepare_get_headers

  describe 'GET /recipes/{:id}' do
    before do
      @author = create(:author)
      @recipe = create(:recipe, author_id: @author.id)
    end

    def get_validate_error(id, params, errors)
      path = "/recipes/#{id}"
      path << "?#{params.to_query}" if params

      get path, headers: @headers

      check_validation_failed(errors)
    end

    context 'success' do
      it 'responds successfully with an HTTP 200 status code' do
        get "/recipes/#{@recipe.id}", headers: @headers
        expect(response).to have_http_status(200)
      end
    end

    context 'validate each params' do
      context 'request_unit' do
        it 'must be equal to imperial or metrics' do
          get_validate_error @recipe.id, { request_unit: 'aaa' },
                             error_response(:not_in_list_error, :request_unit)
        end
      end

      context 'id' do
        it 'must exist in the database' do
          get_validate_error 'dummy_id', {},
                             error_response(:recipe_not_found, :recipe)
        end
      end
    end
  end
end
