class ApplicationController < ActionController::Base
  include GlobalMethods
  include ApplicationHelper

  include Pagy::Method
  allow_browser versions: :modern # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  before_action :authenticate_tenant_user!, unless: :devise_controller?
  before_action :set_tenant_from_subdomain

  around_action :set_tenant_time_zone

  devise_group :tenant_user, contains: [ :tenant_staff, :tenant_login_account ]
  helper_method :current_tenant_user

  private

  def current_tenant_user
    current_tenant_staff || current_tenant_login_account
  end

  def set_tenant_from_subdomain
    return if request.subdomain.blank? || request.subdomain == "www"

    tenant = Tenant.find_by(subdomain: request.subdomain)

    if tenant
      Current.tenant = tenant
    else
      regional_host = request.domain
      redirect_to root_url(host: regional_host, subdomain: nil, error_tag: "not_found"), allow_other_host: true
    end
  end

  def set_tenant_time_zone(&block)
    tz = Current.tenant&.time_zone || "UTC"

    Time.use_zone(tz, &block)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(TenantLoginAccount) && resource.tenant
      verifier = Rails.application.message_verifier(:sso_login)
      token = verifier.generate(resource.id, expires_in: 30.seconds)

      target_url = tenant_sso_verify_url(
        subdomain: resource.tenant.subdomain,
        token: token
      )

      sign_out(resource)

      target_url
    elsif resource.is_a?(TenantStaff)
      tenant_root_url(subdomain: resource.tenant.subdomain)
    else
      super
    end
  end

  def Time
    raise StandardError, "Do not use the Time class directly! Use Time.zone or Time.current"
  end

  def Date
    raise StandardError, "Do not use the Date class directly! Use Time.zone.today or Date.current"
  end
end

# tenant_login_account is for debugging purpose as admin.
