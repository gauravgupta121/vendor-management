class Api::V1::VendorsController < Api::V1::BaseController
  def index
    vendors = Vendor.includes(:services)
                    .page(params[:page])
                    .per(params[:per_page])

    render json: VendorSerializer.new(vendors, {
      meta: pagination_meta(vendors),
      include: [ :services ]
    }).serializable_hash
  end
end
