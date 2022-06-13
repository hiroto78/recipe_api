require 'rails_helper'

RSpec.describe RecipesController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/recipes/1').to route_to('recipes#show', id: '1', format: 'json')
    end

    it 'routes to #create' do
      expect(post: '/recipes').to route_to('recipes#create',  format: 'json')
    end

    it 'routes to #update' do
      expect(put: '/recipes/1').to route_to('recipes#update', id: '1', format: 'json')
    end

    it 'routes to #destroy' do
      expect(delete: '/recipes/1').to route_to('recipes#destroy', id: '1', format: 'json')
    end
  end
end
