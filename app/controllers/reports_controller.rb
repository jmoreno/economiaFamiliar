class ReportsController < ApplicationController

  def index
  	@title = t('.title')
  end

  def monthly
  	
  	yearsOfActivity = Activity.select("strftime('%Y', operationDate) as year").group("strftime('%Y', operationDate)")
  	
  	@years = yearsOfActivity.collect(&:year).sort { |x, y| y <=> x }
  	
  	unless params[:year].blank?
  		@yearSelected = params[:year]
  	else
  		@yearSelected = @years.first
  	end
  	
  	@title = t('.title')

  	totalsByCategory = 
  	Category
  	  	.select("categories.name as category, strftime('%m', activities.operationDate) as monthOperationDate, sum(activities.amount) as totalAmount")
  	  	.joins(:activities)
  	  	.where("strftime('%Y', activities.operationDate) = ?", @yearSelected)
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

  	@title = t('.title')

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
  
  def originsByCategory
  	
  	@categories = Category.all.order(:name)
  	
  	unless params[:category].blank?
  		@categorySelected = params[:category]
  	else
  		@categorySelected = @categories.first.id
  	end
  	
  	yearsOfActivity = Activity.select("strftime('%Y', operationDate) as year").group("strftime('%Y', operationDate)")
  	
  	@years = yearsOfActivity.collect(&:year).sort { |x, y| y <=> x }
  	
  	unless params[:year].blank?
  		@yearSelected = params[:year]
  	else
  		@yearSelected = @years.first
  	end
  	
  	@title = t('.title')

  	origins = 
  	Origin
  	  	.select("origins.name as origin, strftime('%Y', activities.operationDate) as yearOperationDate, count(1) as totalActivities")
  	  	.joins(:activities)
  	  	.where("activities.category_id = ? AND strftime('%Y', activities.operationDate) = ?", @categorySelected, @yearSelected)
  	  	.group("origins.name, strftime('%Y', activities.operationDate)")
  	  	.having("count(1) > ?", 1)
  	  	
  	@pivotTable = PivotTable::Grid.new do |g|
  		g.source_data  = origins
  		g.column_name  = :yearOperationDate
   		g.row_name     = :origin
  		g.value_name   = :amount
  		g.field_name   = :totalActivities
		end
				
		@pivotTable.build
		
	end

end
