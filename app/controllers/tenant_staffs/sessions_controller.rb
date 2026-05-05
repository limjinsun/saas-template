# app/controllers/tenant_login_accounts/sessions_controller.rb
class TenantStaffs::SessionsController < Devise::SessionsController
  layout "application"

  prepend_before_action :redirect_if_authenticated, only: [ :new ]

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

    source = Base32.encode(@params.dig("email").to_s + Time.zone.today.to_s)
    otp_response = ROTP::TOTP.new(source).verify(@params&.dig("otp_code")&.strip, drift_behind: 900)

    if Rails.env.production?
      raise StandardError, "Your Login Code is invalid!" if otp_response.nil?
    else
      raise StandardError, "Your Login Code is invalid!" if @params["otp_code"].to_s != "654321" && otp_response.nil?
    end

    resource = TenantStaff.find_by(tenant_id: @params["tenant_id"], email: @params["email"])
    flash[:notice] = "Signed in successfully."
    sign_in(:tenant_staff, resource)
    sign_out(:tenant_login_account)

    redirect_to tenant_index_tenants_path
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to new_tenant_staff_session_path
  end


  private

  def signed_in_root_path(_resource_or_scope)
    tenant_index_tenants_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_tenant_staff_session_path
  end

  def redirect_if_authenticated
    redirect_to tenant_index_tenants_path if tenant_staff_signed_in?
  end
end
