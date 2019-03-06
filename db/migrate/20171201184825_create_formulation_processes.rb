class CreateFormulationProcesses < ActiveRecord::Migration[5.1]
  def change
    create_table :formulation_processes do |t|
      t.string :hash_id, null: false
      t.references :user
      t.references :development_order, foreign_key: true
      t.string :product_name
      t.string :batch
      t.string :net_amount
      t.string :number_of_cuvettes
      t.date :prorated_expiration_date
      t.date :gustatory_expiration_date
      t.date :microbial_expiration_date
      t.string :product_life
      t.text :equipment_used
      t.string :homogeneization_time
      t.string :temperature
      t.string :total_formulation_time
      t.text :comment

      t.timestamps
    end

    add_index :formulation_processes, :hash_id, unique: true

    add_column :development_orders, :formulation_processes_finished_at,
      :datetime, after: :supplies_authorized_at
  end
end
