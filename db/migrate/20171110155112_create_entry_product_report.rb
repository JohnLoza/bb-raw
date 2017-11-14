class CreateEntryProductReport < ActiveRecord::Migration[5.1]
  def change
    create_table :entry_product_reports do |t|
      t.string :hash_id, null: false, collation: 'utf8_bin'
      t.references :user, foreign_key: true, index: true
      t.bigint :authorizer_id
      t.datetime :authorized_at
      t.boolean :deleted, default: false

      t.timestamps
    end
    add_foreign_key :entry_product_reports, :users, column: :authorizer_id, primary_key: :id
    add_index :entry_product_reports, :authorizer_id

    create_table :entry_product_details do |t|
      t.references :entry_product_report, foreign_key: true, index: true
      t.references :provider_product, foreign_key: true, index: true
      t.string :batch
      t.date :expiration_date
      t.string :invoice_folio
      t.date :invoice_date
      t.decimal :tare, precision: 10, scale: 2
      t.decimal :bulk, precision: 10, scale: 2
    end
  end
end
