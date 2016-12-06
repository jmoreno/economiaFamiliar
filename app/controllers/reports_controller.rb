class ReportsController < ApplicationController

  def index
  end

  def monthly

  	  	totalsByCategory = 
  	  	Category
  	  	.select("categories.name as category, strftime('%m', activities.operationDate) as monthOperationDate, sum(activities.amount) as totalAmount")
  	  	.joins(:activities)
  	  	.where("strftime('%Y', activities.operationDate) = ?", '2016')
  	  	.group("categories.name, strftime('%m', activities.operationDate)")
  	  	
  	  	@pivotTable = PivotTable::Grid.new do |g|
  				g.source_data  = totalsByCategory
  				g.column_name  = :monthOperationDate
  				g.row_name     = :category
  				g.value_name   = :amount
  				g.field_name   = :totalAmount
				end
				
				@pivotTable.build
				
  end

  def yearly

  	  	totalsByCategory = 
  	  	Category
  	  	.select("categories.name as category, strftime('%Y', activities.operationDate) as yearOperationDate, sum(activities.amount) as totalAmount")
  	  	.joins(:activities)
  	  	.group("categories.name, strftime('%Y', activities.operationDate)")
  	  	
  	  	@pivotTable = PivotTable::Grid.new do |g|
  				g.source_data  = totalsByCategory
  				g.column_name  = :yearOperationDate
  				g.row_name     = :category
  				g.value_name   = :amount
  				g.field_name   = :totalAmount
				end
				
				@pivotTable.build
	
  end

end
