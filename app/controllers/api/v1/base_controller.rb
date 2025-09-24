class Api::V1::BaseController < ApplicationController
  # CSRF protection is not needed for API controllers
  before_action :authenticate_request

  # Handle common API errors
  rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
  rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
  rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from StandardError, with: :internal_server_error

  protected

  # Pagination metadata helper
  def pagination_meta(collection)
    {
      pagination: {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
        per_page: collection.limit_value
      }
    }
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end

  def current_user
    @current_user
  end

  def unauthorized_request(exception)
    render json: ErrorSerializer.render_error(exception.message, "401"), status: :unauthorized
  end

  def record_not_found(exception)
    # Log the exception for debugging
    Rails.logger.error "RecordNotFound: #{exception.class} - #{exception.message}"

    # Simple error message
    error_message = "Resource not found"
    render json: ErrorSerializer.render_error(error_message, "404"), status: :not_found
  end

  def record_invalid(exception)
    render json: ErrorSerializer.render_error(exception.message, "422"), status: :unprocessable_entity
  end

  def internal_server_error(exception)
    # Log the exception for debugging
    Rails.logger.error "InternalServerError: #{exception.class} - #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n") if exception.backtrace

    render json: ErrorSerializer.render_error("Something went wrong", "500"), status: :internal_server_error
  end
end
