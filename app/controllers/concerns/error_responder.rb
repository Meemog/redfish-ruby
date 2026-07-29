module ErrorResponder
  extend ActiveSupport::Concern

  def render_error(error:, message:, status:, details: nil)
    response = {
      error: error,
      message: message
    }

    response[:details] = details if details.present?

    render json: response, status: status
  end
end
