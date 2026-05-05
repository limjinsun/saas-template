# spec/models/tenant_spec.rb
require 'rails_helper'

RSpec.describe Tenant, type: :model do
  it "requires a name" do
    expect(build(:tenant, name: nil)).not_to be_valid
  end
end
