class Product < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  belongs_to :provider
  # belongs_to :category
  has_many :stocks

  # Validations needed to save the object into database #
  validates :name, :presentation, presence: true, length: { maximum: 220 }

  scope :recent,  -> { order(updated_at: :DESC) }
  scope :a_z,    -> { order(name: :ASC) }
  scope :z_a,    -> { order(name: :DESC) }

  def to_s
    "#{name}, #{presentation}"
  end
end
