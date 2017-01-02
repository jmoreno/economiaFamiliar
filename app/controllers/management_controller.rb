class ManagementController < ApplicationController
	
  def index
  end

  def template
  	
  	template = FileManager::Template.new()
		flash[:notice] = "Se debería haber descargado un ficherete"
		send_data template.string, :type => "application/excel", :filename => 'EconomiaFamiliar_template.xlsx'
		
 	end

  def import

  	@file = FileManager::File.new({file: params[:file], file_type: params[:file_type]})

  	if @file.valid?
 
 	  	case params[:file_type]
	  	when '1'
				import_status = FileManager::Template.import(params[:file])
	  	when '2'
	  		import_status = FileManager::Santander.import(params[:file])
	  	when '3'
	  		import_status = FileManager::Santander.import_credit_card(params[:file])
	  	when '4'
	  		import_status = FileManager::Bankinter.import(params[:file])
	  	else
	  		import_status = {:error => true} 
	  	end

			if import_status[:error]
				flash[:error] = t('.unsuccessfull_import')
			else
				flash[:notice] = t('.successfull_import')	
			end

  	else

  		flash[:alert] = t('.file_not_present')	

  	end

  	redirect_to management_index_path

  end
  
  def backup
  	@accounts = Account.all
  	@categories = Category.all
  	@regexes = CategoryRegex.all
  	@origins = Origin.all
  	@activities = Activity.includes(:account, :category, :origin).all
#   	render formats: :xls
  	render file: '/management/backup.xls.erb', content_type: 'application/xls'
#   	redirect_to management_index_path, notice: t('.successfull_backup')
  end

  def restore
  	redirect_to management_index_path, notice: t('.successfull_restoring')
  end
end
