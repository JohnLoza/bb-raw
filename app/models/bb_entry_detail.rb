class BbEntryDetail < ApplicationRecord
  belongs_to :bb_entry_report
  belongs_to :bb_product, optional: true

  # Validations needed to save the object into database #
  validates :batch, :expiration_date, :units, presence: true
  validates :units, numericality: { greater_than: 0 }

  def add_to_stock!
    existing_stock =
      BbStock.where(
        bb_product_id: self.bb_product_id,
        batch: self.batch
      ).take

    if existing_stock
      new_units = existing_stock.bulk + self.real_bulk
      new_original_bulk = existing_stock.original_bulk + self.real_bulk
      existing_stock.update_attributes(
        units: (existing_stock.units + self.units),
        original_units: (existing_stock.original_units + self.units)
      )
    else
      stock = BbStock.new
      stock.bb_product_id = self.bb_product_id
      stock.batch = self.batch
      stock.expiration_date = self.expiration_date
      stock.units = self.units
      stock.original_units = stock.units
      stock.save
    end
  end
end
