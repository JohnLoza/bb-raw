class Stock < ApplicationRecord
  include Searchable
  attr_accessor :required_bulk

  belongs_to :product

  validates :batch, :expiration_date, :bulk, :original_bulk, presence: true
  validates :bulk, :original_bulk, numericality: { greater_than: 0 }, on: :create

  scope :recent,      -> { order(created_at: :DESC) }
  scope :depleted,    -> (depleted) {
    if depleted == 'true'
      where(bulk: 0)
    else
      where('bulk > 0')
    end
  }
  scope :by_provider, -> (provider) {
    joins(:product).where(products: {provider_id: provider.id})
  }
  scope :transformed, -> (boolean) {
    if boolean == 'true'
      where(transformed: true)
    else
      where(transformed: false)
    end
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

  # fp = formulation_process
  def Stock.add_transformation_stock(fp)
    bulk = fp.net_amount[/[+-]?([0-9]*[.])?[0-9]+/]
    Stock.create({product_id: fp.development_order.product_id, bulk: bulk,
      original_bulk: bulk, batch: fp.batch, expiration_date: fp.prorated_expiration_date,
      invoice_folio: '---', transformed: true})
  end
end
