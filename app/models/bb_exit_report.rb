class BbExitReport < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  belongs_to :user
  belongs_to :authorizer, class_name: 'User'.freeze,
    foreign_key: :authorizer_id, optional: true
  has_many :details, class_name: 'BbExitDetail'.freeze

  validates :user_id, :destiny, presence: true
  validates :destiny, length: { maximum: 220 }
  validates_associated :details

  scope :recent,  -> { order(updated_at: :DESC) }

  def to_s
    hash_id
  end

  def authorized?
    authorized_at.present?
  end

  def authorize!(user)
    update_attributes(authorizer_id: user.id, authorized_at: Time.now)
    self.details.each do |detail|
      detail.remove_from_stock!
    end
  end

end
