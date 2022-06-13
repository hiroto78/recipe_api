module Domain
  module Models
    class Recipe
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :id, :string
      attribute :title, :string
      attribute :author_id
      attribute :description
      attribute :process
      attribute :request_unit

      attr_reader :ingredient

      validates :title, presence: true, length: { maximum: 100 }, on: :create
      validates :title, presence: true, length: { maximum: 100 }, on: :update, if: proc { |recipe|
                                                                                     !recipe.title.nil?
                                                                                   }

      validates :author_id, presence: true, numericality: { greater_than_or_equal_to: 1 }, on: :create

      validates :description, presence: true, length: { maximum: 200 }, on: :create
      validates :description, length: { maximum: 100 }, on: :update, if: proc { |recipe|
                                                                           !recipe.description.nil?
                                                                         }

      validates :ingredient, presence: true, on: :create

      validates :process, presence: true, length: { maximum: 4000 }, on: :create
      validates :process, length: { maximum: 4000 }, on: :update, if: proc { |recipe|
                                                                        !recipe.process.nil?
                                                                      }

      validates :id, presence: true, on: :update

      validates :request_unit, inclusion: { in: %w[imperial metric] }, unless: -> { request_unit.nil? }

      validate :validate_ingredient

      validate :author_exists?, on: :create
      validate :recipe_exists?, on: :update

      def recipe
        @recipe ||= ::Recipe.by_alive.find_by(id:)
      end

      def recipe_exists?
        errors.add(:recipe, :recipe_not_found, message: 'no recipe found') if recipe.nil?
      end

      def author
        @author ||= ::Author.find_by(id: author_id)
      end

      def author_exists?
        errors.add(:author, :author_not_found, message: 'no author found') if author.nil?
      end

      def ingredient=(attributes)
        @ingredient ||= []

        attributes.each do |item|
          @ingredient << Models::Ingredient.new(item)
        end
      end

      def validate_ingredient
        return unless ingredient

        ingredient.each do |item|
          is_valid = item.valid?

          errors.merge!(item.errors) unless is_valid
        end
      end

      def hash_for_create
        {
          title:,
          description:,
          author_id:,
          ingredient: ingredient.map(&:attributes),
          process:
        }
      end

      def hash_for_update
        {
          title:,
          description:,
          ingredient: ingredient ? ingredient.map(&:attributes) : nil,
          process:
        }.compact
      end
    end
  end
end
