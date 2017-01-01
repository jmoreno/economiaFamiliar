require 'active_support/all'

module FileManager

	class File
		include ActiveModel::Validations
		
		attr_accessor :file, :file_type
		
		validates :file, presence: true
#   	validates_format_of :file, with: %r{\.(xls[mx]?)\z}i, if: "file_type == '1'", message: I18n.t('.unsuccessfull_import')
#   	validates_format_of :file, with: %r{\.(xls[mx]?)\z}i, if: "file_type == '2'", message: I18n.t('.unsuccessfull_import')
#   	validates_format_of :file, with: %r{\.(txt)\z}i, if: "file_type == '3'", message: I18n.t('.unsuccessfull_import')
 
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
			
			worksheet.add_cell(0, 0, 'Operation Date') 
			worksheet.add_cell(0, 1, 'Value Date') 
			worksheet.add_cell(0, 2, 'Description') 
			worksheet.add_cell(0, 3, 'Amount') 
			worksheet.add_cell(0, 4, 'Balance')
	
			worksheet.add_cell(1, 0, DateTime.now.to_date) 
			worksheet.add_cell(1, 1, DateTime.now.to_date) 
			worksheet.add_cell(1, 2, 'Lorem ipsum dolor sit amet consectetur adipiscing elit') 
			worksheet.add_cell(1, 3, 1234.56) 
			worksheet.add_cell(1, 4, 1234567.89)
	
			5.times do |i|
				worksheet.sheet_data[0][i].change_font_name('Calibri') 
				worksheet.sheet_data[1][i].change_font_name('Calibri') 
				worksheet.sheet_data[0][i].change_font_bold(true) 
				worksheet.sheet_data[0][i].change_fill('007fff')
				worksheet.sheet_data[0][i].change_font_color('ffffff')
			end
			
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
						 worksheet[0][4] == 'Balance' )
				  	
					worksheet.drop(1).each { |row|
					 	Activity.new_activity_from_file(account, row[0], row[1], row[2], row[3], row[4])
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
			  		account = Account.find_or_create_by(name: worksheet.cell(4,4))
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
		  	
			  	account = Account.find_or_create_by(name: "Tarjeta de crédito")
			  		
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
			  		account = Account.find_or_create_by(name: items[1])
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

				{:error => true} 

		  rescue Exception => e
		  	
		    Rails.logger.error "file_manager::template.import => exception #{e.class.name} : #{e.message}"
				{:error => true} 

    	end
	
		end
	
	end
					
end