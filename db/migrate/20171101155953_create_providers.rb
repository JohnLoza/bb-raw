class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.string :hash_id, null: false, collation: "utf8_bin"
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :contact
      t.boolean :deleted, default: false

      t.timestamps
    end

    add_index :providers, :hash_id, unique: true
  end
end
