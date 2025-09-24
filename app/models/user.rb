class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
