class ManagementController < ApplicationController
  def index
  end

  def import
  	case params[:file_type]
  	when '1'
  		Activity.import_template(params[:file])
  		flash_message = "Data imported!"
  	when '2'
  		Activity.import_santander(params[:file])
  		flash_message = "Data imported!"
  	when '3'
  		Activity.import_bankinter(params[:file])
  		flash_message = "Data imported!"
  	else
  		flash_message = "Invalid file!"  		
  	end
  	redirect_to management_index_path, notice: flash_message
  end

  def backup
  	redirect_to management_index_path, notice: "Backup created!"
  end

  def restore
  	redirect_to management_index_path, notice: "Backup restored!"
  end
end
