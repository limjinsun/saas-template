class AddTimeZoneToTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :time_zone, :string, default: "UTC", null: false
  end
end
