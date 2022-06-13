require 'rails_helper'

RSpec.describe 'RecipeValidator', type: :request do
  prepare_post_headers

  describe 'POST /recipes' do
    before do
      @author = create(:author)
      @params = {
        title: 'Super Onigiri',
        description: 'This is the best onigiri ever.',
        author_id: @author.id,
        process: 'This is a process of cooking',
        ingredient: [{ item: 'rice', value: '10', unit: 'kg' },
                     { item: 'tuna', value: '5', unit: 'kg' }]
      }

    end

    def post_validate_error(field, value, errors)
      @params[field] = value

      post '/recipes', params: @params.to_json, headers: @headers

      check_validation_failed(errors)
    end

    context 'success' do
      it 'responds successfully with an HTTP 200 status code' do
        post '/recipes', params: @params.to_json, headers: @headers
        expect(response).to have_http_status(201)
      end
    end

    context 'required params' do
      it 'must be required' do
        post '/recipes', headers: @headers
        check_validation_failed(
          error_response(
            :not_blank_error, %i[
              title
              description
              author_id
              process
              ingredient
            ]
          ) +
          error_response(:author_not_found, %i[author]) +
          error_response(:not_a_number_error, %i[author_id])
        )
      end
    end

    context 'validate each params' do
      context 'title' do
        it 'must be greater than or equal to 1' do
          post_validate_error :title, '', error_response(:not_blank_error, :title)
        end

        it 'must be less than or equal to 100' do
          post_validate_error :title, "#{'a' * 100}a", error_response(:too_long_error, :title, max_value: 100)
        end
      end
      # TODO: implement
    end
  end
end
