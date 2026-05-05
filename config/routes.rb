Rails.application.routes.draw do
  authenticate(:tenant_login_account) do
    mount GoodJob::Engine => "good_job"
  end

  # =========================================================
  # 1. Routes for Subdomains (The Tenant App)
  # Must be FIRST — Rails matches top-down. Without this,
  # subdomain requests (acme.lvh.me) fall through to the
  # main domain routes below and hit the marketing page.
  # =========================================================
  constraints(lambda { |req| req.subdomain.present? && req.subdomain != "www" }) do
    root to: redirect('/v2/adminFrame'), as: :tenant_root

    get "sso/verify", to: "tenant_login_accounts/sso#verify", as: :tenant_sso_verify

    devise_for :tenant_staffs, controllers: {
      sessions: "tenant_staffs/sessions",
      registrations: "tenant_staffs/registrations"
    }
    devise_scope :tenant_staff do
      post "tenant_staffs/otp_sign_in", to: "tenant_staffs/sessions#new_otp_login", as: :new_tenant_staff_otp_login
      post "tenant_staffs/otp",         to: "tenant_staffs/sessions#create_otp",    as: :tenant_staff_otp
    end
    namespace :tenant_staffs do
      get :email_suggestions, to: "email_suggestions#index", as: :email_suggestions
    end

    resources :tenants do
      member do
        get :add_staff
        post :staff_create
      end
      collection do
        get :tenant_index
      end
    end

    # Engine B — primary app
    mount EngineB::Engine, at: "/v2"
  end

  # =========================================================
  # 2. Routes for the Main Domain (Marketing / Landing Page)
  # =========================================================
  # This serves as the "Fallback".
  # If the request didn't match the subdomain block above (e.g. it's 'www' or 'localhost'),
  # it falls through to here.
  root "home#index"

  get "home/index", to: "home#index"
  get "home/register", to: "home#register", as: :register_home_index
  get "robots.txt", to: "home#robots", as: :robots

  devise_for :tenant_login_accounts,
    path: "hq/admin",
    controllers: {
      sessions: "tenant_login_accounts/sessions",
      registrations: "tenant_login_accounts/registrations"
    }
  devise_scope :tenant_login_account do
    post "hq/admin/otp_sign_in",
         to: "tenant_login_accounts/sessions#new_otp_login",
         as: :new_tenant_login_account_otp_login

    post "hq/admin/otp",
         to: "tenant_login_accounts/sessions#create_otp",
         as: :tenant_login_account_otp

    post "hq/admin/create_tenant",
         to: "tenant_login_accounts/sessions#create_tenant",
         as: :admin_create_tenant
  end
  namespace :tenant_login_accounts do
    get :email_suggestions, to: "email_suggestions#index", as: :email_suggestions
  end

  if Rails.env.development?
    get "/installHook.js.map", to: proc { [ 204, { "Content-Type" => "text/plain" }, [ "" ] ] }
  end
end
