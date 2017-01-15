class Origin < ApplicationRecord
	has_many :activities
	has_and_belongs_to_many :patterns
end
