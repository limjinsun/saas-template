module EngineB
  class AdminFrameController < ApplicationController
    layout false
    skip_before_action :verify_authenticity_token, only: [:asset]

    def index
    end

    def asset
      base = Rails.root.join("engines/engine_b/app/assets/builds").to_s
      rel = params[:path].to_s
      rel += ".#{params[:format]}" if params[:format].present?

      full = File.expand_path(File.join(base, rel))
      return head :not_found unless full.start_with?(base + File::SEPARATOR)
      return head :not_found unless File.file?(full)

      content_type = case File.extname(full)
      when ".js"  then "text/javascript"
      when ".css" then "text/css"
      when ".map" then "application/json"
      else "application/octet-stream"
      end

      response.headers["Content-Type"] = "#{content_type}; charset=utf-8"
      response.headers["Cache-Control"] = "no-store"
      render plain: File.read(full)
    end
  end
end
