class User < ApplicationRecord
  include SoftDeletable
  include HashId
  include Searchable

  attr_accessor :remember_token, :crop_x, :crop_y, :crop_w, :crop_h,
    :original_width, :original_height
  has_secure_password
  mount_uploader :avatar, AvatarUploader

  ROLES = {
    administration: 'administration'.freeze,
    human_resources: 'human_resources'.freeze,
    warehouse: 'warehouse'.freeze,
    formulation: 'formulation'.freeze,
    packing: 'packing'.freeze,
    entry_authorization: 'entry_authorization'.freeze,
    exit_authorization: 'exit_authorization'.freeze,
    goods: 'goods'.freeze
  }

  before_save :downcase_email
  before_create :set_username

  has_many :entry_product_reports
  has_many :authorized_entry_product_reports,
    class_name: 'EntryProductReport'.freeze, foreign_key: :authorizer_id
  has_many :development_orders
  has_many :bb_entry_reports
  has_many :bb_exit_reports

  # Validations needed to save the object into database
  validates :name, :email, :address,
    presence: true, length: { maximum: 220 }

  validates :phone_number, :cell_phone_number,
    presence: true, length: { maximum: 220 }

  # Validate presence of password when creating an user but not when updating
  validates :password, :password_confirmation,
    presence: true, length: { in: 6..20 }, on: :create
  validates :password, :password_confirmation,
    allow_blank: true, length: { in: 6..20 }, on: :update

  VALID_NAME_REGEX = /\A[a-zA-ZÑñáéíóúü\s\.']+\z/i
  validates :name, format: { with: VALID_NAME_REGEX }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  # The validation is now made inside generate_hash_id method because,
  # if the hash_id is already taken, we want to generate another one
  # validates :hash_id, uniqueness: { case_sensitive: true }

  scope :admin,     -> { where(is_admin: true) }
  scope :non_admin, -> { where(is_admin: false) }
  scope :recent,    -> { order(updated_at: :DESC) }
  scope :by_role,   -> role { where('role LIKE ?', "%#{role}%") }

  def to_s
    name
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Returns the user roles in Array form
  def get_roles
    return Array.new unless roles
    roles.split(Utils::SPLITTER)
  end

  # Returns the user roles for display purposes
  def display_roles
    I18n.t(get_roles, scope: [:activerecord, :attributes, :roles]).join(Utils::SEPARATOR)
  end

  # Returns if the user has or not at least one of the given roles
  def has_role?(role, options={})
    return true if self.admin?
    return true if get_roles.include?(role)

    return unless options[:or].present?
    raise ArgumentError, '\'or\' option must be an Array' unless options[:or].instance_of? Array

    options[:or].each do |other_role|
      return true if get_roles.include?(other_role)
    end
    return false
  end

  # Returns if the user has or not all the given roles
  # The splat (*) will automatically convert all arguments into an Array
  def has_roles?(*roles)
    return true if self.admin?
    roles.each do |r|
      return false unless get_roles.include?(r)
    end
    return true
  end

  def set_roles(roles)
    roles = roles.blank? ? nil : roles.join(Utils::SPLITTER)

    if self.persisted?
      self.update_attributes(roles: roles) unless self.roles == roles
    else
      self.roles = roles
    end
  end

  # Returns the user avatar or default image
  def avatar_url(type = nil)
    unless avatar.blank?
      type.nil? ? avatar.url : avatar.url(type)
    else
      "avatar-male.png".freeze
    end
  end

  # Returns true/false if user is an admin or not
  def admin?
    is_admin
  end

  private
    def downcase_email
      self.email = email.downcase
    end

    def set_username
      self.username = email.split('@')[0] unless self.username.present?
    end
end
