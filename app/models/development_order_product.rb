class DevelopmentOrderProduct < ApplicationRecord
  belongs_to :development_order
  belongs_to :product_category

  validates :bulk, presence: true, numericality: { greater_than: 0 }
end
