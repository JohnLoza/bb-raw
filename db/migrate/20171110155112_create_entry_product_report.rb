class CreateEntryProductReport < ActiveRecord::Migration[5.1]
  def change
    create_table :entry_product_reports do |t|
      t.string :hash_id, null: false
      t.references :user, foreign_key: true, index: true
      t.bigint :authorizer_id
      t.datetime :authorized_at
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :entry_product_reports, :authorizer_id
    add_foreign_key :entry_product_reports, :users, column: :authorizer_id, primary_key: :id
    add_index :entry_product_reports, :hash_id, unique: true
    add_index :entry_product_reports, :deleted_at

    create_table :entry_product_details do |t|
      t.references :entry_product_report, foreign_key: true, index: true
      t.references :product, foreign_key: true, index: true
      t.string :batch
      t.date :expiration_date
      t.string :invoice_folio
      t.date :invoice_date
      t.decimal :tare, precision: 10, scale: 2
      t.decimal :bulk, precision: 10, scale: 2
    end
  end
end
