class CreateTenants < ActiveRecord::Migration[8.0]
  def up
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
    enable_extension "citext"   unless extension_enabled?("citext")

    create_table :tenants do |t|
      t.string :name,      null: false
      t.string :subdomain, null: false
      # secondary UUID (you asked for UUID only as a secondary id on tenants)
      t.uuid   :uuid,      null: false, default: -> { "gen_random_uuid()" }
      t.timestamps
    end

    add_index :tenants, :subdomain, unique: true
    add_index :tenants, :uuid,      unique: true
  end

  def down
    drop_table :tenants, force: :cascade
  end
end
