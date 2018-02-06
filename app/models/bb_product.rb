class BbProduct < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  validates :name, :presentation, presence: true, length: { maximum: 220 }

  scope :recent,  -> { order(updated_at: :DESC) }
  scope :a_z,    -> { order(name: :ASC) }
  scope :z_a,    -> { order(name: :DESC) }

  def to_s
    "#{name}, #{presentation}"
  end
end
