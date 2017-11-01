class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :contact
      t.boolean :deleted, default: false

      t.timestamps
    end

    add_column :providers, :hash_id,
      'VARCHAR(255) CHARACTER SET \'utf8\' COLLATE \'utf8_bin\' NOT NULL', after: :id
    add_index :providers, :hash_id, unique: true
  end
end
