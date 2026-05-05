class TenantsController < ApplicationController
  before_action :ensure_tenant_login_account_own_current_tenant!, only: [ :tenant_index ]

  def tenant_index
    redirect_to root_path
  end

  def add_staff
  end

  def staff_create
    @params = params.permit!
    t      = Current.tenant
    pwd    = SecureRandom.base58(16)
    make_primary = ActiveModel::Type::Boolean.new.cast(@params[:is_primary])

    Tenant.transaction do
      TenantStaff.where(tenant_id: t.id).update_all(is_primary: false) if make_primary
      TenantStaff.create!(
        tenant_id: t.id,
        email: @params[:email].to_s.strip.downcase,
        first_name: @params[:first_name],
        last_name: @params[:last_name],
        job_title: @params[:job_title],
        phone: @params[:phone],
        is_primary: make_primary,
        password: pwd,
        password_confirmation: pwd
      )
    end

    redirect_to tenant_index_tenants_path(t), notice: "Staff user created."
  rescue StandardError => e
    redirect_back fallback_location: tenant_index_tenants_path(t), alert: e.message
  end

  private

  def ensure_tenant_login_account_own_current_tenant!
    user = current_tenant_login_account
    return unless user

    if user.tenant_id != Current.tenant&.id
      sign_out user
      redirect_to root_url, alert: "Unauthorized access."
    end
  end
end
