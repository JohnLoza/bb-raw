class DevelopmentOrderProduct < ApplicationRecord
  belongs_to :development_order
  # belongs_to :category

  validates :product, presence: true, length: { maximum: 220 }
  validates :bulk, presence: true, numericality: { greater_than: 0 }
end
