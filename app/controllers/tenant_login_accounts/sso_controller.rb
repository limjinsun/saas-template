class TenantLoginAccounts::SsoController < ApplicationController
  skip_before_action :authenticate_tenant_user!

  def verify
    verifier = Rails.application.message_verifier(:sso_login)

    begin
      user_id = verifier.verify(params[:token])
      user = TenantLoginAccount.find(user_id)
      if user.tenant.subdomain != request.subdomain
        redirect_to root_url(subdomain: nil), alert: "Security Mismatch: Wrong Tenant."
        return
      end

      sign_out(:tenant_staff)
      sign_in(:tenant_login_account, user)

      redirect_to tenant_index_tenants_path, notice: "Signed in successfully."
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_tenant_login_account_session_url(subdomain: nil), alert: "Login link expired or invalid. Please try again."
    end
  end
end
