# frozen_string_literal: true

class Machine <  ApplicationRecord
  validates :name, presence: true
  validates :input_counts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
