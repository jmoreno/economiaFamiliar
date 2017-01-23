class WelcomeController < ApplicationController

  def index
  	
  end

  def activities
		@activities = Activity.order("operationDate DESC").all
  end

  def balances
  	total_by_account = Activity.group("account_id").sum("amount")
  	@balances = []
  	total_by_account.each do |total|
  		balance = Hash.new
  		account = Account.find(total[0])
  		balance["account_name"] = account.name 
  		balance["balance"] = (total[1] + account.first_balance).round(2)
  		@balances << balance
  	end
  end

  def patterns
  	@patterns = Pattern.all
  end

end
