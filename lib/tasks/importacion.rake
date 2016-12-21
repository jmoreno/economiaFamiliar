namespace :importacion do
	
	require 'rubyXL' # Assuming rubygems is already required
	
  desc "Importación de datos desde la antigua hoja de cálculo"
  task migracion: :environment do
  	
  	Activity.delete_all
  	Origin.delete_all
  	
  	arrayRegex = CategoryRegex.all
  	
  	account = Account.find_or_create_by(name: '0049 5144 05 2616112337')
  		
  	workbook = RubyXL::Parser.parse("#{Rails.root}/lib/assets/private/GastosMorenoRey_20161113.xlsx")
  	worksheet = workbook['MOVIMIENTOS']
  	worksheet.each { |row|
  	
  		activity = Activity.new
  		activity.account = account
  		activity.operationDate = row[0].value
  		activity.valueDate = row[1].value
  		activity.name = row[2].value
  		
  		puts activity.name
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
  		activity.amount = row[3].value
  		activity.balance = row[4].value
  		activity.save
		
		}
  	
  end

end
