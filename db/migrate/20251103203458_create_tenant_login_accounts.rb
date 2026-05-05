class CreateTenantLoginAccounts < ActiveRecord::Migration[8.0]
  def up
    create_table :tenant_login_accounts do |t|
      t.string   :email,                 null: false, default: ""
      t.string   :encrypted_password,    null: false, default: ""
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # trackable + lockable (matching your schema types)
      t.integer  :sign_in_count,         null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.integer  :failed_attempts,       null: false, default: 0
      t.string   :unlock_token
      t.datetime :locked_at

      t.integer  :tenant_id  # nullable in your schema
      t.timestamps
    end

    # indexes
    add_index :tenant_login_accounts, [ :tenant_id, :email ], unique: true, name: "idx_1"
    add_index :tenant_login_accounts, :tenant_id
  end

  def down
    drop_table :tenant_login_accounts, force: :cascade
  end
end
