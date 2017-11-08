class ProductCategory < ApplicationRecord
  before_create :generate_hash_id
  
  has_many :subcategories, class_name: :ProductCategory
  belongs_to :parent_category, class_name: :ProductCategory,
    foreign_key: :product_category_id, optional: true

  validates :name, presence: true, length: { maximum: 250 }

  scope :main_categories, -> { where(product_category_id: nil) }
  scope :a_z,     -> { order(name: :ASC) }
  scope :z_a,     -> { order(name: :DESC) }
  scope :recent,  -> { order(updated_at: :DESC) }
  scope :active,  -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  def to_s
    name
  end

  # Search for users by name or email #
  def self.search_by_sql(args)
    hash = Utils.args_for_mysql(args)

    active.where("name #{hash[:operator]} :args or
      hash_id #{hash[:operator]} :args", args: hash[:args])
  end

  def has_parent?
    product_category_id.present?
  end
end
