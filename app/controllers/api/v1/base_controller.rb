class Api::V1::BaseController < ApplicationController
  # CSRF protection is not needed for API controllers

  # Handle common API errors
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

  def record_not_found(exception)
    render json: {
      errors: [
        {
          status: "404",
          title: "Not Found",
          detail: exception.message
        }
      ]
    }, status: :not_found
  end

  def record_invalid(exception)
    render json: {
      errors: [
        {
          status: "422",
          title: "Unprocessable Entity",
          detail: exception.message
        }
      ]
    }, status: :unprocessable_entity
  end

  def internal_server_error(exception)
    render json: {
      errors: [
        {
          status: "500",
          title: "Internal Server Error",
          detail: "Something went wrong"
        }
      ]
    }, status: :internal_server_error
  end
end
