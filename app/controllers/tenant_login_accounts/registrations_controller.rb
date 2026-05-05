# app/controllers/tenant_login_accounts/registrations_controller.rb
class TenantLoginAccounts::RegistrationsController < Devise::RegistrationsController
  # # POST /tenant_login_accounts
  def create
    # tenant = Tenant.find_by!(subdomain: "app")
    # params = sign_up_params
    # updated_params = params.merge(tenant_id: tenant.id)
    # build_resource(updated_params)

    # resource.save
    # yield resource if block_given?
    # if resource.persisted?
    #   if resource.active_for_authentication?
    #     set_flash_message! :notice, :signed_up

    #     sign_in(resource_name, resource)
    #     respond_with resource, location: after_sign_up_path_for(resource)
    #   else
    #     set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
    #     expire_data_after_sign_in!
    #     respond_with resource, location: after_inactive_sign_up_path_for(resource)
    #   end
    # else
    #   clean_up_passwords resource
    #   set_minimum_password_length
    #   respond_with resource
    # end

    head :ok # Not allow to user create entity.
  end
end
