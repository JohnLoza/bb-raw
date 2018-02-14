class BbExitDetail < ApplicationRecord
  belongs_to :bb_exit_report
  belongs_to :bb_product, optional: true

  # Validations needed to save the object into database #
  validates :batch, :units, presence: true
  validates :units, numericality: { greater_than: 0 }

  def remove_from_stock!
    bb_stock =
      BbStock.find_by!(
        bb_product_id: self.bb_product_id,
        batch: self.batch
      )

    bb_stock.required_units = self.units
    raise StandardError, I18n.t(:no_enough_stock) unless bb_stock.enough_stock?
    bb_stock.update_attributes(
      units: (bb_stock.units - self.units)
    )
  end
end
