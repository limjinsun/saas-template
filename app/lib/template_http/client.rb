# app/lib/template_http/client.rb
module TemplateHttp
  class Client
    def initialize(base_url, headers: {})
      @base_url = base_url
      @headers = headers
    end

    def connection
      @connection ||= Faraday.new(url: @base_url, headers: @headers) do |f|
        f.request :json
        f.response :json
        f.use TemplateHttp::LoggingMiddleware
        f.adapter Faraday.default_adapter
      end
    end
  end
end
