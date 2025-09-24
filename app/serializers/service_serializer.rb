class ServiceSerializer
  include JSONAPI::Serializer

  attribute :vendor_id do |service|
    service.vendor_id
  end

  attribute :vendor_name do |service|
    service.vendor.name
  end

  attributes :name, :status, :start_date, :expiry_date, :payment_due_date, :amount

  attribute :days_until_expiry do |service|
    (service.expiry_date - Date.current).to_i
  end
end
