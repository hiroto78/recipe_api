module Domain
  module Models
    class Ingredient
      include ActiveModel::Model
      include ActiveModel::Attributes

      INGREDIENT = Set.new(
        %i[item value unit]
      ).freeze

      attribute :item
      attribute :value
      attribute :unit

      validates :item, presence: true, length: { maximum: 20 }
      validates :value, presence: true, numericality: { greater_than: 0, less_than: 1_000_000_000 }
      validates :unit, presence: true, inclusion: { in: %w[kg g ounce lb none] }
    end
  end
end
