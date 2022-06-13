require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  prepare_post_headers

  describe 'POST /recipes' do
    context 'success' do
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
      it 'responds successfully with an HTTP 200 status code' do
        post '/recipes', params: @params.to_json, headers: @headers
        expect(response).to have_http_status(201)
      end

      it 'adds 1 recipes record - check count' do
        expect do
          post '/recipes', params: @params.to_json, headers: @headers
        end
          .to change(Recipe, :count)
          .by(1)
      end

      it 'adds 1 recipes record - check record' do
        post '/recipes', params: @params.to_json, headers: @headers
        body = JSON.parse(response.body)
        id = body['id']

        recipe = Recipe.find_by(id:)
        expect(recipe.title).to eq body['title']
        expect(recipe.description).to eq body['description']
        expect(recipe.process).to eq body['process']
        expect(recipe.ingredient).to eq body['ingredient']
        expect(recipe.author_id).to eq body['author']['id']
      end

      it 'responds successfully with correct JSON response' do
        post '/recipes', params: @params.to_json, headers: @headers
        body = JSON.parse(response.body)

        expect(body['title']).to eq @params[:title]
        expect(body['description']).to eq @params[:description]
        expect(body['process']).to eq @params[:process]
        expect(body['ingredient'][0]).to eq @params[:ingredient][0].stringify_keys
        expect(body['ingredient'][1]).to eq @params[:ingredient][1].stringify_keys
        expect(body['author']['id']).to eq @author[:id]
        expect(body['author']['name']).to eq @author[:name]
      end

      # TODO: add request_unit case
    end
  end
end
