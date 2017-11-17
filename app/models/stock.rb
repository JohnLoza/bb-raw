class Stock < ApplicationRecord
  include Searchable
  belongs_to :product

  validates :batch, :expiration_date, :bulk, presence: true
  validates :bulk, numericality: { greater_than: 0 }
end
