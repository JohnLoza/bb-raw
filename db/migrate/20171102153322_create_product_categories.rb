class CreateProductCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :product_categories do |t|
      t.string :hash_id, null: false, collation: "utf8_bin"
      t.references :product_category, foreign_key: true, index: true
      t.string :name
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :product_categories, :hash_id, unique: true
    add_index :product_categories, :deleted_at
  end
end
