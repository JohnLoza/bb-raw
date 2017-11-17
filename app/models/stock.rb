class Stock < ApplicationRecord
  include Searchable
  belongs_to :product, class_name: 'ProviderProduct', foreign_key: :provider_product_id

  validates :batch, :expiration_date, :bulk, presence: true
  validates :bulk, numericality: { greater_than: 0 }
end
