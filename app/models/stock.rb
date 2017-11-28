class Stock < ApplicationRecord
  include Searchable
  attr_accessor :required_bulk

  belongs_to :product

  validates :batch, :expiration_date, :bulk, presence: true
  validates :bulk, numericality: { greater_than: 0 }, on: :create

  scope :unconsumed,  -> { where('bulk > 0') }
  scope :depleted,    -> { where(bulk: 0) }
  scope :by_provider, -> (provider) {
    joins(:product).where(products: {provider_id: provider.id})
  }

  def enough_stock?
    return false unless required_bulk.present?
    self.bulk >= required_bulk
  end

  def withdraw(quantity)
    self.required_bulk = quantity
    raise StandardError, 'No enough stock' unless self.enough_stock?
    update_attributes(bulk: self.bulk - quantity)
  end
end
