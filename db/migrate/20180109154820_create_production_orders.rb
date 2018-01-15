class CreateProductionOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :production_orders do |t|
      t.string :hash_id, null: false, collation: 'utf8_bin'
      t.references :user
      t.references :formulation_process
      t.string :net_amount
      t.string :product_presentation
      t.string :packing_type
      t.string :total_packages
      t.text :comment

      t.timestamps
    end

    add_index :production_orders, :hash_id, unique: true

    add_column :formulation_processes, :presentation_assigned_at,
      :datetime, after: :comment
  end
end
