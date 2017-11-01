class User < ApplicationRecord
  attr_accessor :remember_token, :crop_x, :crop_y, :crop_w, :crop_h,
    :original_width, :original_height

  before_save :downcase_email
  before_create :set_username

  has_secure_password

  mount_uploader :avatar, AvatarUploader

  # Validations needed to save the object into database
  validates :name, :email, :address,
    presence: true, length: { maximum: 250 }

  validates :phone_number, :cell_phone_number,
    presence: true, length: { maximum: 250 }

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
  scope :active,    -> { where(deleted: false) }
  scope :deleted,   -> { where(deleted: true) }
  scope :recent,    -> { order(updated_at: :DESC) }
  scope :by_role,   -> role { where('role LIKE ?', "%#{role}%") }

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Overwrite to_param method to use hash_id attribute instead of default id
  def to_param
    hash_id
  end

  # Search for users by name or email
  def self.search_by_sql(args)
    hash = Utils.args_for_mysql(args)

    non_admin.active
    .where("name #{hash[:operator]} :args or
            email #{hash[:operator]} :args", args: hash[:args])
  end

  # Returns the user roles in Array form
  def get_roles
    return Array.new unless roles
    roles.split(Utils::SPLITTER)
  end

  # Returns the user roles for display purposes
  def display_roles
    I18n.t(get_roles, scope: [:activerecord, :attributes, :roles]).join(Utils::SPLITTER)
  end

  # Returns if the user has or not at least one of the given roles
  # The splat (*) will automatically convert all arguments into an Array
  def has_role?(*roles)
    roles.each do |r|
      return true if get_roles.include?(r)
    end
  end

  # Returns if the user has or not all the given roles
  def has_roles?(*roles)
    roles.each do |r|
      return false unless get_roles.include?(r)
    end
    return true
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
