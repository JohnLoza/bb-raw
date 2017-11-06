class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  before_create :generate_hash_id

  # Overwrite to_param method to use hash_id attribute instead of default id
  def to_param
    self.hash_id
  end

  def active?
    !self.deleted if self.class.column_names.include?('deleted')
  end

  def deleted?
    self.deleted if self.class.column_names.include?('deleted')
  end

  def mark_as_deleted!
    return false unless self.class.column_names.include?('deleted')
    self.update_attributes(deleted: true)
  end

  # search for key_words in certain fields
  def self.search(key_words, *search_in_fields)
    # not search anything if there are no key_words or fields to search for
    return all unless key_words.present? && search_in_fields.present?

    key_words, operator = Utils.get_operator_for_sql_search(key_words)
    query = []

    search_in_fields.each do |field|
      query << "#{field} #{operator} :key_words"
    end

    where(query.join(' OR '), key_words: key_words)
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
