class Current < ActiveSupport::CurrentAttributes
  attribute :tenant

  def tenant_id = tenant&.id
end
