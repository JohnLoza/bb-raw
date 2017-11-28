class Supply < ApplicationRecord
  belongs_to :order, class_name: 'DevelopmentOrder',
    foreign_key: :development_order_id, optional: true
  belongs_to :stock, optional: true

  validates :bulk, presence: true, numericality: { greater_than: 0 }
end
