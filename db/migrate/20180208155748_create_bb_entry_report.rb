class CreateBbEntryReport < ActiveRecord::Migration[5.1]
  def change
    create_table :bb_entry_reports do |t|
      t.string :hash_id, null: false, collation: 'utf8_bin'
      t.references :user, foreign_key: true, index: true
      t.bigint :authorizer_id
      t.datetime :authorized_at
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :bb_entry_reports, :authorizer_id
    add_foreign_key :bb_entry_reports, :users, column: :authorizer_id, primary_key: :id
    add_index :bb_entry_reports, :hash_id, unique: true
    add_index :bb_entry_reports, :deleted_at

    create_table :bb_entry_details do |t|
      t.references :bb_entry_report, foreign_key: true, index: true
      t.references :bb_product, foreign_key: true, index: true
      t.string :batch
      t.date :expiration_date
      t.integer :units
    end

    create_table :bb_stocks do |t|
      t.references :bb_product, foreign_key: true, index: true
      t.string :batch
      t.date :expiration_date
      t.integer :units
      t.integer :original_units

      t.timestamps
    end
  end
end
