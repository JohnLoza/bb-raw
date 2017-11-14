class EntryProductDetail < ApplicationRecord
  belongs_to :entry_product_report
  belongs_to :provider_product, optional: true

  # Validations needed to save the object into database #
  validates :batch, :expiration_date, :invoice_folio, :invoice_date,
    :bulk, presence: true

  validates :tare, allow_nil: true, numericality: { greater_than: 0 }
  validates :bulk, numericality: { greater_than: 0 }

  def real_bulk
    self.bulk - self.tare
  end

  def add_to_stock!
    existing_stock =
      Stock.where(
        provider_product_id: self.provider_product_id,
        batch: self.batch
      ).take

    if existing_stock
      new_bulk = existing_stock.bulk + self.real_bulk
      existing_stock.update_attributes(bulk: new_bulk)
    else
      stock = Stock.new
      stock.provider_product_id = self.provider_product_id
      stock.batch = self.batch
      stock.expiration_date = self.expiration_date
      stock.bulk = self.real_bulk
      stock.save
    end
  end
end
