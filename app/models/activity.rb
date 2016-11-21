class Activity < ApplicationRecord
	belongs_to :category
	belongs_to :account
	belongs_to :origin
end
