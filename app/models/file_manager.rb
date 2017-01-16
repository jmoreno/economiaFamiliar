module FileManager

	class File
		include ActiveModel::Validations
		
		attr_accessor :file, :file_type
		
		validates :file, presence: true
 
 		def initialize(attributes = {})
 			attributes.each do |name, value|
 				send("#{name}=", value)
 			end
		end
		
	end

	class Template

		def self.new
	
	   	workbook = RubyXL::Workbook.new 
			worksheet = workbook[0]
			worksheet.sheet_name = "Template"
			
			['Operation Date', 'Value Date', 'Description', 'Amount', 'Balance', 'Account'].each_with_index { |header, index|
				worksheet.add_cell(0, index, header) 
				worksheet.sheet_data[0][index].change_font_bold(true) 
				worksheet.sheet_data[0][index].change_fill('007fff')
				worksheet.sheet_data[0][index].change_font_color('ffffff')
			}
	  	array_of_samples = [[DateTime.now.to_date, DateTime.now.to_date, 'Lorem ipsum dolor sit amet consectetur adipiscing elit', 1234.56, 1234567.89, 'The very best account in the world']]
			array_of_samples.each_with_index { |sample, index|
				row = index + 1
				sample.each_with_index { |field, column| worksheet.add_cell(row, column, field) }
			}
	
			return workbook.stream
			 
		end
		
		def self.import(file)
			
			begin

		  	workbook = RubyXL::Parser.parse(file.path)

			  worksheet = workbook[0]		  	
				if ( worksheet[0][0] == 'Operation Date' &&	
						 worksheet[0][1] == 'Value Date' &&	
						 worksheet[0][2] == 'Description' &&	
						 worksheet[0][3] == 'Amount' &&	
						 worksheet[0][4] == 'Balance' &&	
						 worksheet[0][5] == 'Account' )
				  	
					worksheet.drop(1).each { |row|
						account = Account.find_or_create_by(reference: row[5].value) do |new_account|
							new_account.name = row[5].value
						end
					 	Activity.new_activity_from_file(account, row[0].value, row[1].value, row[2].value, row[3].value, row[4].value)
					}
					
					{:error => false} 
				
				else

					{:error => true} 

				end
		  rescue Exception => e
		  	
		    Rails.logger.error "file_manager::template.import => exception #{e.class.name} : #{e.message}"
				{:error => true} 

    	end
	  				
		end
			
	end
	
	class Santander
		
		def self.import(file)
			
			begin
		  	workbook = Roo::Spreadsheet.open(file.path)
		  	worksheet = workbook.sheet(0)
		  	
		  	if ( worksheet.cell(4,2) == 'Número de Cuenta: ' && 
		  			 worksheet.cell(11,2) == 'Fecha Operación' &&	
		  			 worksheet.cell(11,4) == 'Fecha Valor' &&	
		  			 worksheet.cell(11,6) == 'Concepto' &&	
		  			 worksheet.cell(11,8) == 'Importe' &&	
		  			 worksheet.cell(11,10) == 'Saldo' )
		  	
			  	if ( worksheet.cell(4,2) == 'Número de Cuenta: ')
						account = Account.find_or_create_by(reference: worksheet.cell(4,4)) do |new_account|
							new_account.name = worksheet.cell(4,4)
						end
			  	end
			  		
			  	worksheet.drop(11).each { |row|
			  		Activity.new_activity_from_file(account, row[0], row[2], row[4], row[6], row[8])
					}
			
					{:error => false} 
				
				else

					{:error => true} 

				end
		  rescue Exception => e
		  	
		    Rails.logger.error "file_manager::template.import => exception #{e.class.name} : #{e.message}"
				{:error => true} 

    	end
    
    end
	  	
		def self.import_credit_card(file)
			
			begin
		  	workbook = Roo::Spreadsheet.open(file.path)
		  	worksheet = workbook.sheet(0)
		  	
		  	if ( worksheet.cell(3,1) == 'Fecha' &&	
		  			 worksheet.cell(3,2) == 'Hora' &&	
		  			 worksheet.cell(3,3) == 'Importe EUR' &&	
		  			 worksheet.cell(3,4) == 'Concepto' &&	
		  			 worksheet.cell(3,5) == 'Situación' )
		  	
					account = Account.find_or_create_by(reference: "Credit Card") do |new_account|
						new_account.name = "Credit Card"
					end
			  		
			  	worksheet.drop(3).each { |row|
			  		if row[0] == 'Importe total:'
			  			break
			  		end
			  		Activity.new_activity_from_file(account, row[0], row[0], row[3], row[2], 0)
					}
			
					{:error => false} 
				
				else

					{:error => true} 

				end
		  rescue Exception => e
		  	
		    Rails.logger.error "file_manager::template.import => exception #{e.class.name} : #{e.message}"
				{:error => true} 

    	end
	  	
		end
		
	end
	
	class Bankinter
		
		def self.import(file)
			
			begin
	
				document = Nokogiri::HTML.fragment(File.open(file.path, "r:iso-8859-1", &:read))
				
				account = nil
				
				document.at('table').search('tr').each_with_index do |row, index|
				  cells = row.search('th, td').map { |cell| cell.text.strip }
					
					if (index == 0 && cells[0] =~ /N*mero de cuenta: (.*)/)
						items = /N*mero de cuenta: (.*)/.match(cells[0])
						account = Account.find_or_create_by(reference: items[1]) do |new_account|
							new_account.name = items[1]
						end
			  		logger.info items[1]
			  		logger.info account
					else 
						if (index == 0)
							break
						end
					end
					
					if (index >= 5)
				  	Activity.new_activity_from_file(account, row[0], row[1], row[2], row[3], row[4])
					end
			
				end

				{:error => false} 

		  rescue Exception => e
		  	
		    Rails.logger.error "file_manager::template.import => exception #{e.class.name} : #{e.message}"
				{:error => true} 

    	end
	
		end
	
	end
					
	class Backup

		def self.create
	
	   	workbook = RubyXL::Workbook.new 
	   	
			worksheet = workbook[0]
			worksheet.sheet_name = "Accounts"
			['Reference', 'Name', 'First Balance'].each_with_index { |header, index|
				worksheet.add_cell(0, index, header) 
				worksheet.sheet_data[0][index].change_font_bold(true) 
				worksheet.sheet_data[0][index].change_fill('007fff')
				worksheet.sheet_data[0][index].change_font_color('ffffff')
			}
			accounts = Account.all.order(:name)
			accounts.each_with_index { |account, index|
				row = index + 1
				[account.reference, account.name, account.first_balance].each_with_index { |field, column| worksheet.add_cell(row, column, field) }
			}

			worksheet = workbook.add_worksheet('Categories')
			['Name'].each_with_index { |header, index|
				worksheet.add_cell(0, index, header) 
				worksheet.sheet_data[0][index].change_font_bold(true) 
				worksheet.sheet_data[0][index].change_fill('007fff')
				worksheet.sheet_data[0][index].change_font_color('ffffff')
			}
	  	categories = Category.all.order(:name)
			categories.each_with_index { |category, index|
				row = index + 1
				[category.name].each_with_index { |field, column| worksheet.add_cell(row, column, field) }
			}

			worksheet = workbook.add_worksheet('Regex for Categories')
			['Regex', 'Category', 'Origin', 'Card', 'Reference', 'Concept', 'Command'].each_with_index { |header, index|
				worksheet.add_cell(0, index, header) 
				worksheet.sheet_data[0][index].change_font_bold(true) 
				worksheet.sheet_data[0][index].change_fill('007fff')
				worksheet.sheet_data[0][index].change_font_color('ffffff')
			}
	  	regexes = CategoryRegex.all.order(:regex)
			regexes.each_with_index do |regex, index|
				row = index + 1
				[regex.regex, regex.category_name, regex.origin, regex.card, regex.reference, regex.concept, regex.command].each_with_index { |field, column|
					worksheet.add_cell(row, column, field)					
				}
			end

			worksheet = workbook.add_worksheet('Origins')
			['Name'].each_with_index { |header, index|
				worksheet.add_cell(0, index, header) 
				worksheet.sheet_data[0][index].change_font_bold(true) 
				worksheet.sheet_data[0][index].change_fill('007fff')
				worksheet.sheet_data[0][index].change_font_color('ffffff')
			}
	  	origins = Origin.select(:name).all.order(:name)
			origins.each_with_index { |origin, index|
				row = index + 1
				[origin.name].each_with_index { |field, column| worksheet.add_cell(row, column, field) }
			}

			worksheet = workbook.add_worksheet('Activities')
			['Operation date', 'Value date', 'Name', 'Amount', 'Balance', 'Account', 'Category', 'Origin', 'Card', 'Concept', 'Commission', 'Reference', 'Command'].each_with_index { |header, index|
				worksheet.add_cell(0, index, header) 
				worksheet.sheet_data[0][index].change_font_bold(true) 
				worksheet.sheet_data[0][index].change_fill('007fff')
				worksheet.sheet_data[0][index].change_font_color('ffffff')
			}
	  	activities = Activity.includes(:account, :category, :origin).all.order(:operationDate)
# 	  	activities = Activity.includes(:account, :category, :origin).limit(42).order(:operationDate)
			activities.each_with_index do |activity, index|
				row = index + 1
			  [activity.operationDate, activity.valueDate, activity.name, activity.amount, activity.balance, defined?(activity.account.name) ? activity.account.name : "", defined?(activity.category.name) ? activity.category.name : "", defined?(activity.origin.name) ? activity.origin.name : "", activity.card, activity.concept, activity.commission, activity.reference, activity.command].each_with_index { |field, column| worksheet.add_cell(row, column, field) }
			end
			
			return workbook.stream
			 
		end
		
		def self.restore(file)
			
			begin

		  	workbook = RubyXL::Parser.parse(file.path)
		  	
		  	worksheet = workbook['Accounts']
		  	headers = ['Reference', 'Name', 'First Balance'] 	 	
		  	are_these_arrays_equals = true
				headers.each_with_index do |header, column| 
					if header != worksheet[0][column].value
						are_these_arrays_equals = false
					end
				end
		  	if are_these_arrays_equals
					worksheet.drop(1).each { |row|
						Account.find_or_create_by(reference: row[0].value) do |new_account|
							new_account.name = row[1].value
							new_account.first_balance = row[2].value
						end
					}
		  	else
		  		raise 'Wrong file! Accounts'
		  	end
		  	
		  	worksheet = workbook['Categories']
		  	headers = ['Name']
		  	are_these_arrays_equals = true
				headers.each_with_index do |header, column| 
					if header != worksheet[0][column].value
						are_these_arrays_equals = false
					end
				end
		  	if are_these_arrays_equals
					worksheet.drop(1).each { |row|
						Category.find_or_create_by(name: row[0].value)
					}
		  	else
		  		raise 'Wrong file! Categories'
		  	end
		  	
		  	worksheet = workbook['Regex for Categories']
		  	headers = ['Regex', 'Category', 'Origin', 'Card', 'Reference', 'Concept', 'Command']
		  	are_these_arrays_equals = true
				headers.each_with_index do |header, column| 
					if header != worksheet[0][column].value
						are_these_arrays_equals = false
					end
				end
		  	if are_these_arrays_equals
					worksheet.drop(1).each { |row|
						CategoryRegex.find_or_create_by(regex: row[0].value) do |regex|
							regex.category = row[1]
							regex.origin = row[2]
							regex.card = row[3]
							regex.reference = row[4]
							regex.concept = row[5]
							regex.command = row[6]
						end
					}		  		
		  	else
		  		raise 'Wrong file! Regex for Categories'
		  	end
		  	
		  	worksheet = workbook['Origins']
		  	headers = ['Name']
		  	are_these_arrays_equals = true
				headers.each_with_index do |header, column| 
					if header != worksheet[0][column].value
						are_these_arrays_equals = false
					end
				end
		  	if are_these_arrays_equals
					worksheet.drop(1).each { |row|
						Origin.find_or_create_by(name: row[0].value)
					}
		  	else
		  		raise 'Wrong file! Origins'
		  	end
		  	
		  	worksheet = workbook['Activities']
		  	headers = ['Operation date', 'Value date', 'Name', 'Amount', 'Balance', 'Account', 'Category', 'Origin', 'Card', 'Concept', 'Commission', 'Reference', 'Command']
		  	are_these_arrays_equals = true
				headers.each_with_index do |header, column| 
					if header != worksheet[0][column].value
						are_these_arrays_equals = false
					end
				end
		  	if are_these_arrays_equals
					worksheet.drop(1).each { |row|
						account = Account.find_or_create_by(reference: row[5].value) do |new_account|
							new_account.name = row[5].value
						end
					 	Activity.new_activity_from_file(account, row[0].value, row[1].value, row[2].value, row[3].value, row[4].value)
					}
					
					{:error => false} 

				else
 	
		    	Rails.logger.error "Me cago en la puta"
					{:error => true} 

		  	end


		  rescue Exception => e
		  	
		    Rails.logger.error "file_manager::template.import => exception #{e.class.name} : #{e.message}"
				{:error => true} 

    	end
	  				
		end
		
	end
	
end