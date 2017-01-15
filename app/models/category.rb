class Category < ApplicationRecord
	has_many :activities
	has_many :patterns
end
