class Tenant < ApplicationRecord
  has_many :tenant_staffs, dependent: :restrict_with_error
  has_one :tenant_login_account, dependent: :destroy

  validates :name, presence: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  RESTRICTED_SUBDOMAINS = %w[www admin api app staging help support mail ftp localhost sandbox].freeze

  validates :subdomain, presence: true, uniqueness: { case_sensitive: false }
  validates :subdomain, exclusion: { in: RESTRICTED_SUBDOMAINS, message: "%{value} is reserved" }
  validates :subdomain, length: { minimum: 2, maximum: 63 }
  validates :subdomain, format: {
    with: /\A[a-z0-9](?:[a-z0-9\-]*[a-z0-9])?\z/i,
    message: "can only contain letters, numbers, and hyphens, and cannot start or end with a hyphen"
  }

  before_destroy :prevent_production_deletion

  private

  def prevent_production_deletion
    if Rails.env.production?
      errors.add(:base, "Direct deletion of Tenants is disabled in Production for safety.")
      throw :abort
    end
  end
end
