class CreateBbExitReport < ActiveRecord::Migration[5.1]
  def change
    create_table :bb_exit_reports do |t|
      t.string :hash_id, null: false, collation: 'utf8_bin'
      t.references :user, foreign_key: true, index: true
      t.bigint :authorizer_id
      t.datetime :authorized_at
      t.string :destiny
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :bb_exit_reports, :authorizer_id
    add_foreign_key :bb_exit_reports, :users, column: :authorizer_id, primary_key: :id
    add_index :bb_exit_reports, :hash_id, unique: true
    add_index :bb_exit_reports, :deleted_at

    create_table :bb_exit_details do |t|
      t.references :bb_exit_report, foreign_key: true, index: true
      t.references :bb_product, foreign_key: true, index: true
      t.string :batch
      t.integer :units
    end
  end
end
