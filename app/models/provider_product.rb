class ProviderProduct < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  belongs_to :provider
  belongs_to :product_category
  has_many :stocks

  # Validations needed to save the object into database #
  validates :name, :presentation, presence: true, length: { maximum: 250 }

  scope :recent,  -> { order(updated_at: :DESC) }

  def to_s
    name
  end

  def name_with_presentation
    "#{name} | #{presentation}"
  end
end
