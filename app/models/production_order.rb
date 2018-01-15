class ProductionOrder < ApplicationRecord
  include HashId
  include Searchable

  attr_accessor :packed_entry_at, :dosage_at, :codify_at, :basketed_at,
    :labeled_at, :packed_exit_at, :warehouse_entry_at, :baskets

  belongs_to :user
  belongs_to :formulation_process

  validates :net_amount, :product_presentation, :packing_type, :total_packages,
    presence: true, length: { maximum: 220 }

  validates :comment, allow_blank: true, length: { maximum: 512 }

  # search for keywords in certain fields
  def search(keywords, *fields)
    return all
  end

end
