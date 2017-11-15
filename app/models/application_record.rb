class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

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
end
