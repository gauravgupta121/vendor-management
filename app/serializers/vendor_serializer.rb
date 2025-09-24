class VendorSerializer
  include JSONAPI::Serializer

  attributes :name, :spoc, :email, :phone, :status, :created_at, :updated_at

  has_many :services, serializer: ServiceSerializer do |vendor, params|
    if params && params[:active_services] == true
      vendor.services.select { |service| service.status == "active" }
    else
      vendor.services
    end
  end
end
