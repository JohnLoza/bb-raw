class Stock < ApplicationRecord
  include Searchable
  attr_accessor :required_bulk

  belongs_to :product

  validates :batch, :expiration_date, :bulk, :original_bulk, presence: true
  validates :bulk, :original_bulk, numericality: { greater_than: 0 }, on: :create

  scope :recent,      -> { order(created_at: :DESC) }
  scope :depleted,    -> (depleted) {
    if depleted
      where(bulk: 0)
    else
      where('bulk > 0')
    end
  }
  scope :by_provider, -> (provider) {
    joins(:product).where(products: {provider_id: provider.id})
  }

  def enough_stock?
    return false unless required_bulk.present?
    self.bulk >= required_bulk
  end

  def withdraw(quantity)
    self.required_bulk = quantity
    raise StandardError, I18n.t(:no_enough_stock) unless self.enough_stock?
    update_attributes(bulk: self.bulk - quantity)
  end
end
