require 'rails_helper'

RSpec.describe Recipe, type: :model do
  before do
    @author = create(:author)
    @recipe = create(:recipe, author_id: @author.id,
                              ingredient: [{
                                item: 'apple',
                                value: 1,
                                unit: 'none'
                              }, {
                                item: 'salt',
                                value: 10,
                                unit: 'g'
                              }, {
                                item: 'sugar',
                                value: 10,
                                unit: 'ounce'
                              }])
  end
  let(:expected_imperialized_ingredient) do
    [{
      item: 'apple',
      value: 1,
      unit: 'none'
    }, {
      item: 'salt',
      value: 0.35,
      unit: 'ounce'
    }, {
      item: 'sugar',
      value: 10,
      unit: 'ounce'
    }]
  end
  let(:expected_metricized_ingredient) do
    [{
      item: 'apple',
      value: 1,
      unit: 'none'
    }, {
      item: 'salt',
      value: 10,
      unit: 'g'
    }, {
      item: 'sugar',
      value: 280.0,
      unit: 'g'
    }]
  end
  describe 'Method' do
    context 'imperialized_ingredient' do
      it 'returns ingredient converted to imperial unit' do
        imperialized_ingredient = @recipe.imperialized_ingredient
        expect(imperialized_ingredient.map(&:deep_symbolize_keys)).to eq(expected_imperialized_ingredient)
      end
      it 'returns ingredient converted to metrics unit' do
        metricized_ingredient = @recipe.metricized_ingredient
        expect(metricized_ingredient.map(&:deep_symbolize_keys)).to eq(expected_metricized_ingredient)
      end
    end
  end
end
