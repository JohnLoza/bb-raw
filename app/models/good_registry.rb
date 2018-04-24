class GoodRegistry < ApplicationRecord
  include Searchable

  USE = 'use'.freeze
  RETRIEVE = 'retrieve'.freeze

  belongs_to :good
  belongs_to :user

  validates :descriptor, presence: true, length: { maximum: 220 }

  scope :recent,    -> { order(updated_at: :DESC) }

  def to_s
    hash_id
  end
end
