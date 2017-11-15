class EntryProductReport < ApplicationRecord
  include SoftDeletable
  include HashId

  belongs_to :user
  belongs_to :authorizer, class_name: 'User'.freeze,
    foreign_key: :authorizer_id, optional: true
  has_many :details, class_name: :EntryProductDetail

  validates :user_id, presence: true
  validates_associated :details

  scope :recent,  -> { order(updated_at: :DESC) }

  def to_s
    hash_id
  end

  def authorized?
    authorized_at.present?
  end

  def authorize!(user)
    ActiveRecord::Base.transaction do
      update_attributes(authorizer_id: user.id, authorized_at: Time.now)
      self.details.each do |detail|
        raise ActiveRecord::Rollback unless detail.add_to_stock!
      end
    end
  end

end
