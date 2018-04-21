class CreateDevolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :devolutions do |t|
      t.string :hash_id, null: false, collation: "utf8_bin"
      t.references :user, foreign_key: true, index: true
      t.bigint :authorizer_id
      t.references :stock, foreign_key: true, index: true
      t.decimal :bulk, precision: 10, scale: 2
      t.string :description
      t.datetime :authorized_at
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :devolutions, :hash_id, unique: true
    add_index :devolutions, :authorizer_id
    add_foreign_key :devolutions, :users, column: :authorizer_id, primary_key: :id
    add_index :devolutions, :deleted_at
  end
end
