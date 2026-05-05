# app/controllers/tenant_login_accounts/email_suggestions_controller.rb
class TenantLoginAccounts::EmailSuggestionsController < ApplicationController
  skip_before_action :authenticate_tenant_user!  # don’t require login to view suggestions

  def index
    q = params[:q].to_s.strip

    items =
      if q.length >= 2
        TenantLoginAccount
          .joins(:tenant)
          .where("LOWER(tenant_login_accounts.email) = ?", q.downcase)
          .order("tenant_login_accounts.email ASC, tenants.name ASC")
          .pluck("tenant_login_accounts.email", "tenant_login_accounts.tenant_id", "tenants.name")
          .map { |email, tenant_id, tenant_name| { email: email, tenant_id: tenant_id, tenant_name: tenant_name } }
      else
        []
      end

    render json: { items: items } # => [{ email, tenant_id, tenant_name }, ...]
  end
end
