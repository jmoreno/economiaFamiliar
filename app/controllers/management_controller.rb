class ManagementController < ApplicationController
	
  def index
  end

  def template
  	template = FileManager::Template.new()
		send_data template.string, :type => "application/excel", :filename => 'EconomiaFamiliar_template.xlsx'
 	end

  def import

  	@file = FileManager::FileImported.new({file: params[:file], file_type: params[:file_type]})

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
  	backup = FileManager::Backup.create()
		send_data backup.string, :type => "application/excel", :filename => 'EconomiaFamiliar_backup.xlsx'
  end

  def restore

  	@file = FileManager::FileImported.new({file: params[:file], file_type: params[:file_type]})

  	if @file.valid?
	  	import_status = FileManager::Backup.restore(params[:file])
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
end
