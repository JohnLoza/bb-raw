class CreateProviderProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :provider_products do |t|
      t.string :hash_id, null: false, collation: "utf8_bin"
      t.references :provider
      t.references :product_category
      t.string :name
      t.string :presentation
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :provider_products, :hash_id, unique: true
    add_index :provider_products, :deleted_at
  end
end
