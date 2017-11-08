class ProviderProduct < ApplicationRecord
  before_create :generate_hash_id

  belongs_to :provider
  belongs_to :product_category
  has_many :stocks

  # Validations needed to save the object into database #
  validates :name, :presentation, presence: true, length: { maximum: 250 }

  scope :recent,  -> { order(updated_at: :DESC) }
  scope :active,  -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  def to_s
    name
  end
end
