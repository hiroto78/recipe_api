module RecipeApi
  # RecipeApi::Validator
  module Validator
    # RecipeApi::Validator::Error
    module Error
      class BaseError < StandardError
        attr_reader :error

        def initialize(message = nil, error: nil)
          super(message)

          @error = error&.errors
        end
      end

      class ValidationFailed < BaseError
      end

      module_function

      RecipeApiErrors = Struct.new(:errors)
      RecipeApiErrorMessage = Struct.new(:attribute, :type, :message)

      def generate(attribute, type, message)
        RecipeApiErrors.new(
          [
            RecipeApiErrorMessage.new(
              attribute,
              type,
              message
            )
          ]
        )
      end
    end
  end
end
