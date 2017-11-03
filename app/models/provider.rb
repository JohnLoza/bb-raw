class Provider < ApplicationRecord
  has_many :products, class_name: :ProviderProduct, dependent: :destroy

  # Validations needed to save the object into database #
  validates :name, :address, :phone_number, :contact, presence: true, length: { maximum: 250 }

  scope :recent,  -> { order(updated_at: :DESC) }
  scope :active,  -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  # Search for users by name or email #
  def self.search_by_sql(args)
    hash = Utils.args_for_mysql(args)

    active.where("name #{hash[:operator]} :args or
      hash_id #{hash[:operator]} :args", args: hash[:args])
  end
end
