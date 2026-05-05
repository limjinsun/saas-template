EngineB::Engine.routes.draw do
  root "admin_frame#index"

  # AdminFrame — active template UI
  get "adminFrame", to: "admin_frame#index"
  get "adminFrame/assets/*path", to: "admin_frame#asset", format: false
  get "adminFrame/*path", to: "admin_frame#index"

  # Template-only endpoints used by the active SaaS shell
  scope "template", controller: :template do
    get :bootstrap
  end
end
