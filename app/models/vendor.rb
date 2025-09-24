class Vendor < ApplicationRecord
  # Associations
  has_many :services, dependent: :destroy

  # Enum
  enum :status, { active: "active", inactive: "inactive" }

  # Validations
  validates :name, presence: true
  validates :spoc, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  validates :phone, presence: true,
            format: { with: /\A\d{10}\z/ },
            length: { is: 10 }

  # Callbacks
  before_validation :normalize_email
  before_validation :normalize_phone

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end

  def normalize_phone
    self.phone = phone.gsub(/\D/, "") if phone.present?
  end
end
