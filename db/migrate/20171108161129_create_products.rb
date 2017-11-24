class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :hash_id, null: false, collation: "utf8_bin"
      t.references :provider
      t.string :name
      t.string :presentation
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :products, :hash_id, unique: true
    add_index :products, :deleted_at
  end
end
