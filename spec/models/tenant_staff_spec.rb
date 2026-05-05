# spec/models/tenant_staff_spec.rb
require 'rails_helper'

RSpec.describe TenantStaff, type: :model do
  include_context "with current tenant"

  it "is valid with tenant + email" do
    expect(build(:tenant_staff, tenant: tenant)).to be_valid
  end

  it "validates email presence & format" do
    s = build(:tenant_staff, tenant: tenant, email: nil)
    expect(s).not_to be_valid
    s.email = "not-an-email"
    expect(s).not_to be_valid
  end

  it "enforces email uniqueness scoped to tenant" do
    create(:tenant_staff, tenant: tenant, email: "dup@example.com")
    dup = build(:tenant_staff, tenant: tenant, email: "dup@example.com")
    expect(dup).not_to be_valid
  end
end
