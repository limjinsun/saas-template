class HomeController < ApplicationController
  skip_before_action :authenticate_tenant_user!

  def index
    render layout: "application_marketing"
  end

  def register
    render layout: "application_marketing"
  end

  def pricing_comparison
    redirect_to register_home_index_path
  end

  def robots
    canonical_host = ENV.fetch("APP_CANONICAL_HOST", "example.com")
    content = if Rails.env.production? && request.host == canonical_host
      "User-agent: *\nAllow: /\n"
    else
      "User-agent: *\nDisallow: /\n"
    end
    render plain: content, content_type: "text/plain"
  end

  private
end
