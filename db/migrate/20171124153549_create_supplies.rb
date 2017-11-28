class CreateSupplies < ActiveRecord::Migration[5.1]
  def change
    create_table :supplies do |t|
      t.references :development_order
      t.references :stock
      t.decimal :bulk, precision: 10, scale: 2

      t.timestamps
    end

    add_column :development_orders, :supplier_id, :bigint, after: :required_date
    add_column :development_orders, :supplied_at, :datetime, after: :supplier_id

    add_index :development_orders, :supplier_id
    add_foreign_key :development_orders, :users, column: :supplier_id, primary_key: :id

    add_column :development_orders, :supplies_authorizer_id, :bigint, after: :supplied_at
    add_column :development_orders, :supplies_authorized_at, :datetime, after: :supplies_authorizer_id

    add_index :development_orders, :supplies_authorizer_id
    add_foreign_key :development_orders, :users, column: :supplies_authorizer_id, primary_key: :id
  end
end
