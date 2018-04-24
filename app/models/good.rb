class Good < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  belongs_to :last_used_by_user, class_name: 'User'.freeze,
    foreign_key: :last_used_by, optional: true
  has_many :registries, class_name: 'GoodRegistry'.freeze, dependent: :destroy

  validates :name, presence: true, length: { maximum: 220 }

  scope :recent,    -> { order(updated_at: :DESC) }

  def to_s
    name
  end
end
