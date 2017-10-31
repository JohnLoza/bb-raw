class UserRole
  WAREHOUSE = 'warehouse'.freeze
  FORMULATION = 'formulation'.freeze
  PROCESSES = 'processes'.freeze
  PACKING = 'packing'.freeze
  LOGISTICS = 'logistics'.freeze
  ACCOUNTING = 'accounting'.freeze

  def self.available_roles
    [
      WAREHOUSE,
      FORMULATION,
      PROCESSES,
      PACKING,
      LOGISTICS,
      ACCOUNTING
    ].freeze
  end
end
