class ApplicationController < ActionController::API
  include ErrorResponder

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :validation_error
  rescue_from ActiveRecord::RecordNotUnique, with: :conflict_error
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :invalid_json

  private

  def record_not_found(exception)
    Rails.logger.info("Not found: #{exception.message}")

    render_error(
      error: "NOT_FOUND",
      message: "The requested resource does not exist.",
      status: :not_found
    )
  end

  def validation_error(exception)
    Rails.logger.info("Validation Error: #{exception.message}")

    render_error(
      error: "INVALID_REQUEST",
      message: "One or more request fields are invalid.",
      details: exception.record.errors.to_hash,
      status: :bad_request
    )
  end

  def invalid_json(exception)
    Rails.logger.info("Invalid JSON: #{exception.message}")

    render_error(
      error: "INVALID_REQUEST",
      message: "One or more request fields are invalid.",
      status: :bad_request
    )
  end

  def conflict_error(exception)
    Rails.logger.info("Conflict Error: #{exception.message}")

    render_error(
      error: "CONFLICT",
      message: "A resource already exists.",
      status: :conflict
    )
  end
end
