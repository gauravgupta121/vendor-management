class Api::V1::ServicesController < Api::V1::BaseController
  before_action :set_service, only: [ :update_status ]
  before_action :validate_status, only: [ :update_status ]

  def expiring_services
    services = Service.includes(:vendor)
                      .expiring_in
                      .page(params[:page])
                      .per(params[:per_page])

    render json: ServiceSerializer.new(services, {
      meta: pagination_meta(services)
    }).serializable_hash
  end

  def upcoming_payments
    services = Service.includes(:vendor)
                      .upcoming_payment_in
                      .page(params[:page])
                      .per(params[:per_page])

    render json: ServiceSerializer.new(services, {
      meta: pagination_meta(services)
    }).serializable_hash
  end

  def update_status
    if @service.update(status: service_params[:status])
      render json: ServiceSerializer.new(@service).serializable_hash
    else
      render json: ErrorSerializer.render_error(@service, "422"), status: :unprocessable_entity
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.render_error("Service not found", "404"), status: :not_found
  end

  def validate_status
    valid_statuses = Service.statuses.keys
    requested_status = service_params[:status]

    unless valid_statuses.include?(requested_status)
      error_message = "Invalid status '#{requested_status}'. Valid statuses are: #{valid_statuses.join(', ')}"
      render json: ErrorSerializer.render_error(error_message, "422"), status: :unprocessable_entity
    end
  end

  def service_params
    params.require(:service).permit(:status)
  end
end
