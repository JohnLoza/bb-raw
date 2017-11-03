class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  before_create :generate_hash_id

  # Overwrite to_param method to use hash_id attribute instead of default id
  def to_param
    self.hash_id
  end

  def active?
    !self.deleted if self.class.column_names.include? :deleted
  end

  def deleted?
    self.deleted if self.class.column_names.include? :deleted
  end

  def mark_as_deleted!
    self.update_attributes(deleted: true) if self.class.column_names.include? 'deleted'
  end

  private
    def generate_hash_id
      loop do
        self.hash_id = Utils.new_alphanumeric_token
        break unless hash_id_taken?(self.hash_id)
      end
    end

    def hash_id_taken?(hash_id)
      self.class.find_by(hash_id: hash_id)
    end
end
