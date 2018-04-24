class CreateGoods < ActiveRecord::Migration[5.1]
  def change
    create_table :goods do |t|
      t.string :hash_id, null: false, collation: "utf8_bin"
      t.bigint :last_used_by
      t.datetime :last_used_at
      t.string :name
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :goods, :hash_id, unique: true
    add_index :goods, :deleted_at

    create_table :good_registries do |t|
      t.references :good
      t.references :user
      t.string :descriptor

      t.timestamps
    end
  end
end
