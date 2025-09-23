class Api::V1::ServicesController < Api::V1::BaseController
  def expiring_soon
    services = Service.includes(:vendor)
                      .expiring_in(10)
                      .page(params[:page])
                      .per(params[:per_page])

    render json: ServiceSerializer.new(services, {
      meta: pagination_meta(services)
    }).serializable_hash
  end
end
