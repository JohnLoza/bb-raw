class CreateStock < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.references :product, foreign_key: true, index: true
      t.string :batch
      t.date :expiration_date
      t.string :invoice_folio
      t.date :invoice_date
      t.decimal :bulk, precision: 10, scale: 2
      t.decimal :original_bulk, precision: 10, scale: 2

      t.timestamps
    end
  end
end
