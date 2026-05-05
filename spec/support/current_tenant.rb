# spec/support/current_tenant.rb
# Simple helpers for setting Current.tenant
RSpec.shared_context "with current tenant" do
  let(:tenant) { create(:tenant) }

  around do |ex|
    previous = Current.tenant
    Current.tenant = tenant
    ex.run
  ensure
    Current.tenant = previous
  end
end
