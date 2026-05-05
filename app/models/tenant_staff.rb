class TenantStaff < ApplicationRecord
  include TenantScoped

  # Pick the modules you want. Common for internal apps (no self-signup):
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :timeoutable,
         :trackable # optional

  # Scoped validations (replace :validatable)
  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :email, uniqueness: { scope: :tenant_id, case_sensitive: false }

  def self.find_for_authentication(warden_conditions)
    # This acts as a firewall, preventing cross-tenant lookups
    where(tenant_id: Current.tenant_id).where(warden_conditions).first
  end
end
