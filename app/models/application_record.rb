class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_create :generate_hash_id

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
