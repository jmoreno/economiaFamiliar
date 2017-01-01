class Activity < ApplicationRecord
	belongs_to :category
	belongs_to :account
	belongs_to :origin
	
	def self.new_activity_from_file (account, operationDate, valueDate, name, amount, balance)

		activity = Activity.new
		activity.account = account
		activity.operationDate = operationDate
		activity.valueDate = valueDate
		activity.name = name
		
		arrayRegex = CategoryRegex.all
						  		
		arrayRegex.each do |regex|
						  			
			if ( activity.name =~ /#{Regexp.new(regex.regex)}/ )
				activity.category = Category.find_or_create_by(name: regex.category_name)
				items = /#{Regexp.new(regex.regex)}/.match(activity.name)
				if (regex.origin > 0)
					activity.origin = Origin.find_or_create_by(name: items[regex.origin].strip)
				end
				if (regex.card > 0)
					activity.card = items[regex.card].strip
				end
				if (regex.reference > 0)
					activity.reference = items[regex.reference].strip
				end
				if (regex.concept > 0)
					activity.concept = items[regex.concept].strip
				end
				if (regex.command > 0)
					activity.command = items[regex.command].strip
				end
				break		  			
			end
							  		
		end
	
		activity.amount = amount
		activity.balance = balance
		activity.save
						  		
	end
			
end
