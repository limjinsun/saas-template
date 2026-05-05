# spec/factories/tenants.rb
FactoryBot.define do
  factory :tenant do
    sequence(:name)      { |n| "Tenant #{n}" }
    sequence(:subdomain) { |n| "tenant#{n}" } # ← ensure NOT NULL + unique
  end
end
