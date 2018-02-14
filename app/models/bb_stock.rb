class BbStock < ApplicationRecord
  include Searchable
  attr_accessor :required_units

  belongs_to :bb_product

  validates :batch, :expiration_date, :units, :original_units, presence: true
  validates :units, :original_units, numericality: { greater_than: 0 }, on: :create

  scope :recent,      -> { order(created_at: :DESC) }
  scope :depleted,    -> (depleted) {
    if depleted
      where(units: 0)
    else
      where('units > 0')
    end
  }

  def enough_stock?
    return false unless required_units.present?
    self.units >= required_units
  end

  def withdraw(quantity)
    self.required_units = quantity
    raise StandardError, 'No enough stock' unless self.enough_stock?
    update_attributes(units: self.units - quantity)
  end
end
