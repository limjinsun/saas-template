require "rails_helper"

RSpec.describe TenantLoginAccount, type: :model do
  let(:tenant) { create(:tenant) }

  it "requires an email" do
    account = described_class.new(tenant: tenant, email: nil, password: "Password!123")

    expect(account).not_to be_valid
    expect(account.errors[:email]).to be_present
  end

  it "requires a valid email format" do
    account = described_class.new(tenant: tenant, email: "not-an-email", password: "Password!123")

    expect(account).not_to be_valid
    expect(account.errors[:email]).to be_present
  end
end
