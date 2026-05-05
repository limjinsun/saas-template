# app/lib/template_http/logging_middleware.rb
module TemplateHttp
  class LoggingMiddleware < Faraday::Middleware
    def call(env)
      Rails.logger.info("\e[44;37m [API OUT] \e[0m \e[34m#{env.method.upcase} #{env.url}\e[0m")
      Rails.logger.info("\e[34mPayload: #{env.body}\e[0m") if env.body

      start_time = Time.current
      @app.call(env).on_complete do |response_env|
        duration = ((Time.current - start_time) * 1000).round(1)
        status = response_env.status
        color = status >= 400 ? "\e[31m" : "\e[32m"

        Rails.logger.info("#{color}[API IN] #{status} (#{duration}ms)\e[0m")
        Rails.logger.info("#{color}Response: #{response_env.body}\e[0m")
      end
    end
  end
end
