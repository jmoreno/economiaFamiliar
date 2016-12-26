class ManagementController < ApplicationController
  def index
  end

  def template
  	
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
		 
		send_data workbook.stream.string, :type => "application/excel", :filename => 'EconomiaFamiliar_template.xlsx', alert: "Se debería haber descargado un ficherete"
		
 	end

  def import
  	case params[:file_type]
  	when '1'
  		Activity.import_template(params[:file])
  		flash[:notice] = t('.successfull_import')
  	when '2'
  		Activity.import_santander(params[:file])
  		flash[:notice] = t('.successfull_import')
  	when '3'
  		Activity.import_bankinter(params[:file])
  		flash[:notice] = t('.successfull_import')
  	else
  		flash[:alert] = t('.unsuccessfull_import')
  	end
  	redirect_to management_index_path, notice: flash_message
  end
  
  def backup
  	redirect_to management_index_path, notice: t('.successfull_backup')
  end

  def restore
  	redirect_to management_index_path, notice: t('.successfull_restoring')
  end
end
