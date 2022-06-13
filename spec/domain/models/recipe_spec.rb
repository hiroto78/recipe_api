require 'rails_helper'

RSpec.describe Domain::Models::Recipe, type: :model do
  let(:model) { Domain::Models::Recipe }

  context('validation') do
    before do
      @author = create(:author)
    end
    let(:valid_params) do
      {
        title: 'Great rice ball',
        description: 'This is a good rice ball',
        process: 'The process of cooking',
        author_id: @author.id,
        ingredient: [
          { item: 'apple',
            value: 1,
            unit: 'none' },
          { item: 'salt',
            value: 10,
            unit: 'g' }
        ],
        request_unit: 'imperial'
      }
    end

    let(:recipe) { model.new(valid_params) }

    it('passes validation for valid params') { expect(recipe.valid?(:create)).to be true }

    # rubocop:disable Metrics/AbcSize
    def expect_validation_error(action, field, value, errors)
      valid_params[field] = value

      expect(recipe.valid?(action)).to be false

      expect(recipe.errors.errors.map(&:attribute).uniq.size).to eql(1)
      expect(recipe.errors.errors[0].attribute).to eql(field)
      expect(recipe.errors.errors.map(&:type)).to contain_exactly(*errors)
    end
    # rubocop:enable Metrics/AbcSize

    def expect_validation_pass(action, field, value)
      valid_params[field] = value

      expect(recipe.valid?(action)).to be true
    end

    describe('title') do
      it('fails for nil title') { expect_validation_error(:create, :title, nil, :blank) }
      it('fails for title too long') { expect_validation_error(:create, :title, 'a' * 101, :too_long) }

      it('passes for max length title') { expect_validation_pass(:create, :title, 'a' * 100) }
      it('passes for min length title') { expect_validation_pass(:create, :title, 'a') }
    end

    describe('description') do
      it('fails for nil description') { expect_validation_error(:create, :description, nil, :blank) }
      it('fails for description too long') { expect_validation_error(:create, :description, 'a' * 201, :too_long) }

      it('passes for max length description') { expect_validation_pass(:create, :description, 'a' * 200) }
      it('passes for min length description') { expect_validation_pass(:create, :description, 'a') }
    end

    describe('process') do
      it('fails for nil process') { expect_validation_error(:create, :process, nil, :blank) }
      it('fails for process too long') { expect_validation_error(:create, :process, 'a' * 4001, :too_long) }

      it('passes for max length process') { expect_validation_pass(:create, :process, 'a' * 4000) }
      it('passes for min length process') { expect_validation_pass(:create, :process, 'a') }
    end

    describe('request_unit') do
      it('fails for dummy request unit') { expect_validation_error(:create, :request_unit, 'dummy', :inclusion) }
      it('passes for nil request unit') { expect_validation_pass(:create, :request_unit, nil) }
    end

    # TODO: implement
  end
end
