class CreateStock < ActiveRecord::Migration[5.1]
  def change
    create_table :stocks do |t|
      t.references :provider_product, foreign_key: true, index: true
      t.string :batch
      t.date :expiration_date
      t.decimal :bulk, precision: 10, scale: 2

      t.timestamps
    end
  end
end
