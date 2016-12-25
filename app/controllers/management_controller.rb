class ManagementController < ApplicationController
  def index
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
