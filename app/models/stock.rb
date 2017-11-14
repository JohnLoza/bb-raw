class Stock < ApplicationRecord
  belongs_to :provider_product

  validates :batch, :expiration_date, :invoice_folio, :invoice_date,
    :bulk, presence: true
  validates :bulk, numericality: { greater_than: 0 }
end
