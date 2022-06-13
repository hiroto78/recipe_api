module ErrorHandler
  extend ActiveSupport::Concern

  ERROR_CODE_MAP = {
    blank: :required,
    inclusion: :not_in_list
  }.freeze

  included do
    around_action :handle_error
  end

  def handle_error
    yield
  rescue RecipeApi::Validator::Error::ValidationFailed => e
    render json: json_body(:bad_request, e), status: :bad_request
  rescue StandardError => e
    render json: json_body(:internal_server_error, e), status: :internal_server_error
  end

  private

    def json_body(code, error)
      body = {
        code:,
        detail: detail(error)
      }
      if %i[bad_request].include?(code)
        Rails.logger.debug(body)
      else
        Rails.logger.error(body)
      end
      body
    end

    def detail(error)
      return error if error.is_a?(Array)
      return error unless error.respond_to?(:error)
      return JSON.parse(error.message) if error.error.nil?

      message_list = []
      error.error.each do |error_details|
        key = error_details.attribute.to_s

        message_list << {
          key:,
          error_code: ERROR_CODE_MAP[error_details.type] || error_details.type,
          message: error_details.message
        }
      end
      message_list
    rescue StandardError
      error
    end
end
