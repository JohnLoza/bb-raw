class CreateBbProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :bb_products do |t|
      t.string :hash_id, null: false
      t.string :name
      t.string :presentation
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :bb_products, :hash_id, unique: true
    add_index :bb_products, :deleted_at
  end
end
