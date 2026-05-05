# app/controllers/tenant_login_accounts/sessions_controller.rb
class TenantLoginAccounts::SessionsController < Devise::SessionsController
  layout "application"

  if ENV["HQ_ADMIN_USER"].present? && ENV["HQ_ADMIN_PASSWORD"].present?
    http_basic_authenticate_with(
      name: ENV["HQ_ADMIN_USER"],
      password: ENV["HQ_ADMIN_PASSWORD"],
      except: [ :destroy ]
    )
  end
  before_action :ensure_signed_out!, only: [ :new_otp_login, :create_otp ]

  def new_otp_login
    @params = params.permit!
    target_email = @params&.dig("email").to_s

    @otp_source = Base32.encode(@params&.dig("email") + Time.zone.today.to_s)
    @otp_code = ::ROTP::TOTP.new(@otp_source).now
    begin
      TemplateHttp::ApiClients::Resend.new.send_email(
        to: target_email,
        subject: "Your Workspace Login Code",
        html: ApplicationController.render(
          layout: "resend_email",
          template: "emails/login_otp",
          assigns: { otp_code: @otp_code }
        )
      )
    rescue StandardError => e
      # Log the error if the API request hard-crashes, so the user isn't stuck
      Rails.logger.error("\e[31m[Resend API Error] Failed to send OTP: #{e.message}\e[0m")
    end
  end

  def create_otp
    @params = params.permit!

    @otp_source = Base32.encode(@params&.dig("email") + Time.zone.today.to_s)
    otp_response = ROTP::TOTP.new(@otp_source).verify(@params&.dig("otp_code")&.strip, drift_behind: 900)

    if Rails.env.production?
      raise StandardError, "Your Login Code is invalid!" if otp_response.nil?
    else
      raise StandardError, "Your Login Code is invalid!" if @params["otp_code"].to_s != "654321" && otp_response.nil?
    end

    @resource = TenantLoginAccount.find_by(tenant_id: @params&.dig("tenant_id"))
    verifier = Rails.application.message_verifier(:sso_login)
    token = verifier.generate(@resource.id, expires_in: 30.seconds)
    sign_out(@resource)
    redirect_to tenant_sso_verify_url(subdomain: @resource.tenant.subdomain, token: token), allow_other_host: true
  rescue StandardError => error
    flash[:error] = error.message
    redirect_to new_tenant_login_account_session_path
  end

  def create_tenant
    @params = params.permit!

    ActiveRecord::Base.transaction do
      tenant = Tenant.create!(
        name: @params[:name],
        subdomain: @params[:subdomain].to_s.downcase.parameterize,
        time_zone: @params[:time_zone]
      )

      temp_password = SecureRandom.hex(10)
      TenantStaff.create!(
        tenant: tenant,
        email: @params[:owner_email],
        first_name: @params[:owner_first_name],
        last_name: @params[:owner_last_name],
        is_primary: true,
        password: temp_password,
        password_confirmation: temp_password
      )

      TenantLoginAccount.create!(
        tenant: tenant,
        email: ENV["SUPPORT_EMAIL"].presence || "support@example.test",
        password: SecureRandom.hex(32)
      )

      flash[:notice] = "✅ Workspace Created! Owner Password: #{temp_password}"
      redirect_to new_tenant_login_account_session_path
    end

  rescue StandardError => e
    flash[:error] = "Failed: #{e.message}"
    redirect_to new_tenant_login_account_session_path
  end

  private

  def ensure_signed_out!
    sign_out(:tenant_login_account) if tenant_login_account_signed_in?
  end

  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?

    no_input = new_session_path(resource_name)

    if resource = warden.user(resource_name)
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(resource), allow_other_host: true
    end
  end
end
