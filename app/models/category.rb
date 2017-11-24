class Category < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  has_many :subcategories, class_name: 'Category'.freeze
  belongs_to :parent_category, class_name: 'Category'.freeze,
    foreign_key: :category_id, optional: true

  validates :name, presence: true, length: { maximum: 220 }

  scope :main_categories, -> { where(category_id: nil) }
  scope :a_z,     -> { order(name: :ASC) }
  scope :z_a,     -> { order(name: :DESC) }
  scope :recent,  -> { order(updated_at: :DESC) }

  def to_s
    name
  end

  def has_parent?
    category_id.present?
  end
end
