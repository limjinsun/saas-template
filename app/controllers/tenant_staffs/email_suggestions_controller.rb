# app/controllers/tenant_login_accounts/email_suggestions_controller.rb
class TenantStaffs::EmailSuggestionsController < ApplicationController
  skip_before_action :authenticate_tenant_user!  # don’t require login to view suggestions

  def index
    q = params[:q].to_s.strip

    # 1. Safety Check: If we are not on a subdomain (no Current.tenant), return empty.
    if Current.tenant.nil?
      render json: { items: [] }
      return
    end

    items =
      if q.length >= 2
        TenantStaff
          # 2. KEY CHANGE: Scope strictly to the current tenant
          .where(tenant_id: Current.tenant.id)
          .where("LOWER(email) = ?", q.downcase)
          .limit(1) # We only expect 1 match because email is unique per tenant
          .pluck(:email, :tenant_id)
          .map do |email, tenant_id|
            {
              email: email,
              tenant_id: tenant_id,
              # 3. Optimization: No need to query DB for name, we already have it in memory
              tenant_name: Current.tenant.name
            }
          end
      else
        []
      end

    # The frontend expects an array, so we return an array (max size 1)
    render json: { items: items }
  end
end
