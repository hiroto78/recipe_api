require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  prepare_put_headers

  describe 'PUT /recipes/:id' do
    context 'success' do
      before do
        @author = create(:author)
        @author_for_rating1 = create(:author)
        @author_for_rating2 = create(:author)
        @recipe = create(:recipe, author_id: @author[:id])
        create(:rating, author_id: @author_for_rating1.id, recipe_id: @recipe.id)
        create(:rating, author_id: @author_for_rating2.id, recipe_id: @recipe.id)
        @params = {
          title: 'Hyper Onigiri'
        }
      end
      it 'responds successfully with an HTTP 200 status code' do
        put "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        expect(response).to have_http_status(200)
      end

      it 'adds 0 recipes record - check count' do
        expect do
          put "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        end
          .to change(Recipe, :count)
          .by(0)
      end

      it 'updates a recipe record - check record' do
        put "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        body = response.body

        recipe_id = JSON.parse(body)['id']
        recipe = Recipe.find(recipe_id)

        expect(recipe.title).to eq @params[:title]
        expect(recipe.description).to eq @recipe.description
        expect(recipe.process).to eq @recipe.process
        expect(recipe.ingredient).to eq @recipe.ingredient
        expect(recipe.deleted_at).to eq nil
      end

      it 'responds successfully with correct JSON response' do
        put "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        body = JSON.parse(response.body)

        expect(body['title']).to eq @params[:title]
        expect(body['description']).to eq @recipe[:description]
        expect(body['process']).to eq @recipe[:process]
        expect(body['ingredient']).to eq @recipe[:ingredient]
        expect(body['author']['id']).to eq @author[:id]
        expect(body['author']['name']).to eq @author[:name]
        expect(body['ratings'][0]['rate']).to eq 10
        expect(body['ratings'][0]['author_id']).to eq @author_for_rating1.id
        expect(body['ratings'][1]['rate']).to eq 10
        expect(body['ratings'][1]['author_id']).to eq @author_for_rating2.id
      end

      # TODO: add request_unit case
    end
  end
end
