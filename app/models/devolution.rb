class Devolution < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  belongs_to :user
  belongs_to :authorizer, class_name: 'User'.freeze,
    foreign_key: :authorizer_id, optional: true
  belongs_to :stock

  validates :bulk, presence: true, numericality: true
  validates :description, presence: true, length: { maximum: 220 }

  scope :recent,  -> { order(created_at: :DESC) }

  def to_s
    hash_id
  end

  def authorized?
    authorized_at.present?
  end

  def authorize!(user)
    ActiveRecord::Base.transaction do
      update_attributes(authorizer_id: user.id, authorized_at: Time.now)
      self.stock.withdraw(bulk)
    end
  end
end
