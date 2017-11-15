class Provider < ApplicationRecord
  include SoftDeletable
  include HashId

  has_many :products, class_name: 'ProviderProduct'.freeze, dependent: :destroy

  # Validations needed to save the object into database #
  validates :name, :address, :phone_number, :contact, presence: true, length: { maximum: 250 }

  scope :recent,  -> { order(updated_at: :DESC) }

  def to_s
    name
  end
end
