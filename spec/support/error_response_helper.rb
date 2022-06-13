module ErrorResponseHelper
  def error_response(error_method, fields, opts = {})
    Array.wrap(fields).map do |field|
      error_details = send(error_method, opts)

      { key: field }.merge(error_details)
    end
  end

  def author_not_found(_opts = {}) =
    { error_code: :author_not_found, message: 'no author found' }

  def not_a_number_error(_opts = {}) =
    { error_code: :not_a_number, message: 'is not a number' }

  def not_blank_error(_opts = {}) =
    { error_code: :required, message: "can't be blank" }

  def not_in_list_error(_opts = {}) =
    { error_code: :not_in_list, message: 'is not included in the list' }

  def recipe_not_found(_opts = {}) =
    { error_code: :recipe_not_found, message: 'no recipe found' }

  def too_long_error(opts = {})
    character_plural = "character#{opts[:max_value] == 1 ? '' : 's'}"

    { error_code: :too_long, message: "is too long (maximum is #{opts[:max_value]} #{character_plural})" }
  end

  def too_short_error(opts = {})
    character_plural = "character#{opts[:min_value] == 1 ? '' : 's'}"

    { error_code: :too_short, message: "is too short (minimum is #{opts[:min_value]} #{character_plural})" }
  end
end
