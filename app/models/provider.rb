class Provider < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  has_many :products, dependent: :destroy

  # Validations needed to save the object into database #
  validates :name, :address, :phone_number, :contact, presence: true, length: { maximum: 220 }

  scope :recent, -> { order(updated_at: :DESC) }
  scope :a_z,    -> { order(name: :ASC) }
  scope :z_a,    -> { order(name: :DESC) }

  def to_s
    name
  end
end
