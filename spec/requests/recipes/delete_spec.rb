require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  prepare_put_headers

  describe 'DELETE /recipes/:id' do
    before do
      Timecop.freeze(Time.utc(2022, 8, 8))
    end

    context 'success' do
      before do
        @author = create(:author)
        @recipe = create(:recipe, author_id: @author[:id])
      end
      it 'responds successfully with an HTTP 200 status code' do
        delete "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        expect(response).to have_http_status(200)
      end

      it 'adds 0 recipes record - check count' do
        expect do
          delete "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        end
          .to change(Recipe, :count)
          .by(0)
      end

      it 'updates a recipe record - check record' do
        delete "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        body = response.body

        recipe_id = JSON.parse(body)['id']
        recipe = Recipe.find(recipe_id)

        expect(recipe.title).to eq @recipe.title
        expect(recipe.description).to eq @recipe.description
        expect(recipe.process).to eq @recipe.process
        expect(recipe.ingredient).to eq @recipe.ingredient
        expect(recipe.deleted_at).to eq Time.now
      end

      it 'responds successfully with correct JSON response' do
        delete "/recipes/#{@recipe.id}", params: @params.to_json, headers: @headers
        body = JSON.parse(response.body)

        expect(body['id']).to eq @recipe.id
      end
    end

    after do
      Timecop.return
    end
  end
end
