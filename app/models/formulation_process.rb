class FormulationProcess < ApplicationRecord
  include HashId

  belongs_to :user
  belongs_to :development_order

  validates :batch, presence: true, length: { is: 10 }

  validates :product, :net_amount, :number_of_cuvettes, :product_life,
    :homogeneization_time, :temperature, :total_formulation_time,
    presence: true, length: { maximum: 220 }

  validates :prorated_expiration_date, :gustatory_expiration_date,
    :microbial_expiration_date, presence: true, length: { maximum: 20 }

  validates :equipment_used, presence: true, length: { maximum: 512 }
  validates :comment, allow_blank: true, length: { maximum: 512 }

end
