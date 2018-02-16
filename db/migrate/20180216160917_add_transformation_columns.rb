class AddTransformationColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :stocks, :transformed, :boolean, default: false, after: :original_bulk
    add_reference :development_orders, :product, index: true, after: :hash_id
    add_column :development_orders, :for_transformation, :boolean, default: false, after: :deleted_at
  end
end
