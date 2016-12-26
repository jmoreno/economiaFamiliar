class Activity < ApplicationRecord
	belongs_to :category
	belongs_to :account
	belongs_to :origin
	
	def self.import_santander(file)
		
  	workbook = Roo::Spreadsheet.open(file.path)
  	worksheet = workbook.sheet(0)
  	
  	if ( worksheet.cell(4,2) == 'Número de Cuenta: ' && 
  			 worksheet.cell(11,2) == 'Fecha Operación' &&	
  			 worksheet.cell(11,4) == 'Fecha Valor' &&	
  			 worksheet.cell(11,6) == 'Concepto' &&	
  			 worksheet.cell(11,8) == 'Importe' &&	
  			 worksheet.cell(11,10) == 'Saldo' )
  	
			arrayRegex = CategoryRegex.all

	  	if ( worksheet.cell(4,2) == 'Número de Cuenta: ')
	  		account = Account.find_or_create_by(name: worksheet.cell(4,4))
	  	end
	  		
	  	worksheet.drop(11).each { |row|
	  		logger.info row.inspect
	  		activity = Activity.new
	  		activity.account = account
	  		activity.operationDate = row[0]
	  		activity.valueDate = row[2]
	  		activity.name = row[4]
	  		
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
	  		activity.amount = row[6]
	  		activity.balance = row[8]
	  		activity.save
			
			}
		
		end
  	
	end
		
	def self.import_template(file)
		
  	workbook = RubyXL::Parser.parse(file.path)
  	worksheet = workbook[0]
  	
  	if ( worksheet[0][0] == 'Operation Date' &&	
  			 worksheet[0][1] == 'Value Date' &&	
  			 worksheet[0][2] == 'Description' &&	
  			 worksheet[0][3] == 'Amount' &&	
  			 worksheet[0][4] == 'Balance' )
  			 
			arrayRegex = CategoryRegex.all

# 	  	if ( worksheet[3][1] == 'Número de Cuenta: ')
# 	  		account = Account.find_or_create_by(name: worksheet[4][4])
# 	  	end
	  		
	  	worksheet.drop(1).each { |row|
	  	
	  		activity = Activity.new
	  		activity.account = account
	  		activity.operationDate = row[0].value
	  		activity.valueDate = row[1].value
	  		activity.name = row[2].value
	  		
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
	
	def self.import_bankinter(file)

		arrayRegex = CategoryRegex.all
		
		document = Nokogiri::HTML.fragment(File.open(file.path, "r:iso-8859-1", &:read))
		
		account = nil
		
		document.at('table').search('tr').each_with_index do |row, index|
		  cells = row.search('th, td').map { |cell| cell.text.strip }
			
			if (index == 0 && cells[0] =~ /N*mero de cuenta: (.*)/)
				items = /N*mero de cuenta: (.*)/.match(cells[0])
	  		account = Account.find_or_create_by(name: items[1])
	  		logger.info items[1]
	  		logger.info account
			else 
				if (index == 0)
					break
				end
			end
			
			if (index >= 5)
				
				logger.info account
				
	  		activity = Activity.new
	  		activity.account = account
	  		activity.operationDate = cells[0]
	  		activity.valueDate = cells[1]
	  		activity.name = cells[2]
	  		
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
	  		activity.amount = cells[3]
	  		activity.balance = cells[4]
	  		activity.save
			
			end
		
		end

	end
		
end
