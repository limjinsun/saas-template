# app/lib/template_http/api_clients/resend.rb
module TemplateHttp
  class ApiClients::Resend < Client
    TEST_EMAIL_DOMAINS = %w[example.com email.com test.com].freeze

    def initialize
      super(
        "https://api.resend.com",
        headers: { "Authorization" => "Bearer #{ENV['RESEND_API_KEY']}" }
      )
    end

    def send_email(to:, subject:, html: nil, text: nil, headers: nil)
      if test_address?(to)
        Rails.logger.info("[Resend] Skipped test recipient: #{to}")
        return { skipped: true, to: to, reason: "test-domain" }
      end

      merged_headers = { "X-Entity-Ref-ID" => SecureRandom.uuid }.merge(headers || {})
      from_name = ENV.fetch("APP_EMAIL_FROM_NAME", "SaaS Template")
      from_email = ENV.fetch("APP_EMAIL_FROM_ADDRESS", "no-reply@example.test")

      payload = {
        from: "#{from_name} <#{from_email}>",
        to: to,
        subject: subject,
        headers: merged_headers
      }
      payload[:html] = html if html
      payload[:text] = text if text

      connection.post("/emails", payload)
    end

    private

    def test_address?(to)
      addresses = Array(to).map { |address| address.to_s.strip.downcase }
      addresses.any? { |address| TEST_EMAIL_DOMAINS.any? { |domain| address.end_with?("@#{domain}") } }
    end
  end
end
