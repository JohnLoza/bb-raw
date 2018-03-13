class FormulationProcess < ApplicationRecord
  include HashId
  include Searchable

  belongs_to :user
  belongs_to :development_order

  scope :on_production, -> (on_production) {
    if on_production
      where.not(presentation_assigned_at: nil)
    else
      where(presentation_assigned_at: nil)
    end
  }
  scope :recent,  -> { order(created_at: :DESC) }
  scope :ancient, -> { order(created_at: :ASC) }
  scope :for_transformation, -> (boolean) {
    joins(:development_order).where(development_orders: { for_transformation: boolean })
  }

  validates :batch, presence: true, length: { is: 10 }

  validates :product_name, :net_amount, :number_of_cuvettes, :product_life,
    :homogeneization_time, :temperature, :total_formulation_time,
    presence: true, length: { maximum: 220 }

  validates :prorated_expiration_date, :gustatory_expiration_date,
    :microbial_expiration_date, presence: true, length: { maximum: 20 }

  validates :equipment_used, presence: true, length: { maximum: 512 }
  validates :comment, allow_blank: true, length: { maximum: 512 }

end
