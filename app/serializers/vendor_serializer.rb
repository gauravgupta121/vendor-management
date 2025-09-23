class VendorSerializer
  include JSONAPI::Serializer

  attributes :name, :spoc, :email, :phone, :status, :created_at, :updated_at

  has_many :services, serializer: ServiceSerializer do |vendor|
    vendor.services.select { |service| service.expiry_date >= Date.current }
  end
end
