class DevelopmentOrder < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  belongs_to :user
  belongs_to :supplier, class_name: 'User'.freeze,
    foreign_key: :supplier_id, optional: true
  belongs_to :supplies_authorizer, class_name: 'User'.freeze,
    foreign_key: :supplies_authorizer_id, optional: true
  has_many :required_products, class_name: 'DevelopmentOrderProduct',
    dependent: :destroy
  has_many :supplies, dependent: :destroy
  has_many :formulation_processes, dependent: :destroy

  validates :description, :required_date, presence: true
  validates :description, length: { maximum: 220 }

  validates_associated :required_products

  scope :not_supplied_first, -> { order(supplied_at: :ASC) }
  scope :recent,  -> { order(updated_at: :DESC) }
  scope :ancient, -> { order(updated_at: :ASC) }
  scope :by_user, -> (user_id) { where(user_id: user_id) }
  scope :order_by_required_date, -> { order(required_date: :ASC) }

  scope :authorized, -> (boolean) {
    if boolean
      where.not(supplies_authorized_at: nil)
    else
      where(supplies_authorized_at: nil)
    end
  }

  scope :with_closed_processes, -> (boolean) {
    if boolean
      where.not(formulation_processes_finished_at: nil)
    else
      where(formulation_processes_finished_at: nil)
    end
  }

  def to_s
    hash_id
  end

  def supplied?
    supplied_at.present?
  end

  def set_supplier(user)
    self.update_attributes(supplier_id: user.id, supplied_at: Time.now)
  end

  def supplies_authorized?
    supplies_authorized_at.present?
  end

  def formulation_processes_finished?
    formulation_processes_finished_at.present?
  end

  def set_supplies_authorizer(user)
    self.update_attributes(supplies_authorizer_id: user.id,
      supplies_authorized_at: Time.now)
  end
end
