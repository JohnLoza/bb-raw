class DevelopmentOrder < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  belongs_to :user
  has_many :required_products, class_name: 'DevelopmentOrderProduct'

  validates :description, :required_date, presence: true
  validates :description, length: { maximum: 220 }

  validates_associated :required_products

  scope :not_supplied_first, -> { order(supplied_at: :ASC) }
  scope :recent,  -> { order(updated_at: :DESC) }
  scope :ancient, -> { order(updated_at: :ASC) }

  def to_s
    hash_id
  end

  def supplied?
    supplied_at.present?
  end
end
