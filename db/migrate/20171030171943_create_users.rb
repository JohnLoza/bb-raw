class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :hash_id, null: false
      t.string :email
      t.string :name
      t.string :username
      t.string :address
      t.string :phone_number
      t.string :cell_phone_number
      t.string :password_digest
      t.string :remember_digest
      t.string :roles
      t.string :avatar
      t.boolean :is_admin, default: false
      t.datetime :deleted_at

      t.timestamps
    end
    
    # add index to email and hash_id in users table #
    # add_column :users, :hash_id, null: false, after: :id
    add_index :users, :hash_id, unique: true
    add_index :users, :email, unique: true
    add_index :users, :deleted_at
  end
end
