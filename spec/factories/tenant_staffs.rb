# spec/factories/tenant_staffs.rb
FactoryBot.define do
  factory :tenant_staff do
    association :tenant
    sequence(:email) { |n| "staff#{n}@example.com" }
    password { "Password!123" }
  end
end
