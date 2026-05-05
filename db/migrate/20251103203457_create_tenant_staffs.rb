class CreateTenantStaffs < ActiveRecord::Migration[8.0]
  def up
    create_table :tenant_staffs do |t|
      t.integer :tenant_id, null: false
      t.citext  :email,     null: false

      t.string  :first_name
      t.string  :last_name
      t.string  :job_title
      t.string  :phone
      t.boolean :is_primary, default: false, null: false
      t.jsonb   :metadata,   default: {},    null: false

      # Devise fields present in your schema
      t.string   :encrypted_password,      null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count,           null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip
      t.integer  :failed_attempts,         null: false, default: 0
      t.string   :unlock_token
      t.datetime :locked_at

      t.timestamps
    end

    add_index :tenant_staffs, [ :tenant_id, :email ], unique: true, name: "index_tenant_staffs_on_tenant_and_email"
    add_index :tenant_staffs, :tenant_id
    add_index :tenant_staffs, :reset_password_token, unique: true
    # one primary staff per tenant (partial unique)
    add_index :tenant_staffs, :tenant_id, unique: true, where: "(is_primary = true)", name: "unique_primary_staff_per_tenant"

    add_foreign_key :tenant_staffs, :tenants, column: :tenant_id
  end

  def down
    remove_foreign_key :tenant_staffs, column: :tenant_id
    drop_table :tenant_staffs, force: :cascade
  end
end
