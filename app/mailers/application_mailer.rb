class ApplicationMailer < ActionMailer::Base
  default from: -> {
    name = ENV.fetch("APP_EMAIL_FROM_NAME", "SaaS Template")
    address = ENV.fetch("APP_EMAIL_FROM_ADDRESS", "no-reply@example.test")
    "#{name} <#{address}>"
  }
  layout "mailer"
end
