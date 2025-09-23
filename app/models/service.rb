class Service < ApplicationRecord
  # Associations
  belongs_to :vendor

  # Validations
  validates :name, presence: true
  validates :start_date, presence: true
  validates :expiry_date, presence: true
  validates :payment_due_date, presence: true
  validates :amount, presence: true,
            numericality: { greater_than: 0, less_than: 99999999.99 }

  # Custom validations
  validate :expiry_date_after_start_date
  validate :payment_due_date_after_start_date
  validate :unique_service_name_per_vendor

  # Scopes
  scope :active, -> { where("expiry_date >= ?", Date.current) }
  scope :expired, -> { where("expiry_date < ?", Date.current) }
  scope :payment_due, -> { where("payment_due_date <= ?", Date.current) }
  scope :upcoming_payment, -> { where("payment_due_date BETWEEN ? AND ?", Date.current, 30.days.from_now) }

  private

  def expiry_date_after_start_date
    return unless start_date && expiry_date

    if expiry_date <= start_date
      errors.add(:expiry_date, "must be after start date")
    end
  end

  def payment_due_date_after_start_date
    return unless start_date && payment_due_date

    if payment_due_date < start_date
      errors.add(:payment_due_date, "must be on or after start date")
    end
  end

  def unique_service_name_per_vendor
    return unless name && vendor_id

    existing_service = Service.where(vendor_id: vendor_id, name: name)
                            .where.not(id: id)

    if existing_service.exists?
      errors.add(:name, "must be unique per vendor")
    end
  end
end
