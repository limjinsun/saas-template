# app/models/concerns/tenant_scoped.rb
module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :tenant
    before_validation :set_tenant_from_current, on: :create
    validates :tenant_id, presence: true
    validate :tenant_id_immutable, on: :update
    default_scope { where(tenant_id: Current.tenant_id) if Current.tenant_id }
  end

  private

  def set_tenant_from_current
    self.tenant_id ||= Current.tenant_id
  end

  def tenant_id_immutable
    if will_save_change_to_tenant_id? && tenant_id_before_last_save.present?
      errors.add(:tenant_id, "cannot be changed once set")
    end
  end
end
