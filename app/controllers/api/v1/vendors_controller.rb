class Api::V1::VendorsController < Api::V1::BaseController
  before_action :set_vendor, only: [ :show, :update, :destroy ]

  def index
    vendors = Vendor.includes(:services)
                    .page(params[:page])
                    .per(params[:per_page])

    # Show all services by default, only active if explicitly requested
    active_services = params[:active_services] == "true"

    render json: VendorSerializer.new(vendors, {
      meta: pagination_meta(vendors),
      include: [ :services ],
      params: { active_services: active_services }
    }).serializable_hash
  end

  def show
    render json: VendorSerializer.new(@vendor, {
      include: [ :services ]
    }).serializable_hash
  end

  def create
    vendor = Vendor.new(vendor_params)

    if vendor.save
      render json: VendorSerializer.new(vendor, {
        include: [ :services ]
      }).serializable_hash, status: :created
    else
      render json: ErrorSerializer.render_error(vendor, "422"), status: :unprocessable_entity
    end
  end

  def update
    if @vendor.update(vendor_params)
      render json: VendorSerializer.new(@vendor, {
        include: [ :services ]
      }).serializable_hash
    else
      render json: ErrorSerializer.render_error(@vendor, "422"), status: :unprocessable_entity
    end
  end

  def destroy
    @vendor.destroy
    head :no_content
  end

  private

  def set_vendor
    @vendor = Vendor.includes(:services).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: ErrorSerializer.render_error("Vendor not found", "404"), status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(
      :name, :spoc, :email, :phone, :status,
      services_attributes: [
        :id, :name, :start_date, :expiry_date, :payment_due_date, :amount, :_destroy
      ]
    )
  end
end
