class CreateDevelopmentOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :development_orders do |t|
      t.string :hash_id, null: false, collation: 'utf8_bin'
      t.references :user
      t.string :description
      t.date :required_date
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :development_orders, :hash_id, unique: true
    add_index :development_orders, :deleted_at

    create_table :development_order_products do |t|
      t.references :development_order
      t.string :product
      t.decimal :bulk, precision: 10, scale: 2
    end
  end
end
