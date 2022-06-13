require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  prepare_get_headers

  describe 'GET /recipes/:id' do
    before do
      @author = create(:author)
      @author_for_rating1 = create(:author)
      @author_for_rating2 = create(:author)
      @recipe = create(:recipe, author_id: @author[:id])
      create(:rating, author_id: @author_for_rating1.id, recipe_id: @recipe.id)
      create(:rating, author_id: @author_for_rating2.id, recipe_id: @recipe.id)
    end

    context 'success' do
      it 'responds successfully with an HTTP 200 status code' do
        get "/recipes/#{@recipe.id}", headers: @headers
        expect(response).to have_http_status(200)
      end

      it 'responds successfully with correct JSON response' do
        get "/recipes/#{@recipe.id}", headers: @headers

        body = JSON.parse(response.body)

        expect(body['id']).to eq @recipe.id
        expect(body['title']).to eq @recipe.title
        expect(body['description']).to eq @recipe.description
        expect(body['process']).to eq @recipe.process
        expect(body['ingredient'][0]).to eq @recipe.ingredient[0]
        expect(body['ingredient'][1]).to eq @recipe.ingredient[1]
        expect(body['author']['id']).to eq @author.id
        expect(body['author']['name']).to eq @author.name
        expect(body['ratings'][0]['rate']).to eq 10
        expect(body['ratings'][0]['author_id']).to eq @author_for_rating1.id
        expect(body['ratings'][1]['rate']).to eq 10
        expect(body['ratings'][1]['author_id']).to eq @author_for_rating2.id
      end
      # TODO: add request_unit case
    end
  end
end
