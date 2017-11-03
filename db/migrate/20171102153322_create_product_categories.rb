class CreateProductCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :product_categories do |t|
      t.references :product_category, foreign_key: true, index: true
      t.string :name
      t.boolean :deleted, default: false

      t.timestamps
    end

    add_column :product_categories, :hash_id,
      'VARCHAR(255) CHARACTER SET \'utf8\' COLLATE \'utf8_bin\' NOT NULL', after: :id
    add_index :product_categories, :hash_id, unique: true
  end
end
