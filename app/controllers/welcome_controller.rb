class WelcomeController < ApplicationController

  def index
  	
  end

  def activities
		@activities = Activity.order("operationDate DESC").all
  end

  def balances
  	@balances = Activity.group("account_id").select("account_id, ' ' as account_name, SUM(amount) as total_amount, 0 as balance, MAX(operationDate) as max_operation_date")
  	@balances.each do |balance|
  		account = Account.find(balance['account_id'])
  		balance["account_name"] = account.name 
  		balance["balance"] = (balance['total_amount'] + account.first_balance).round(2)
  	end
  end

  def patterns
  	@patterns = Pattern.all
  end

end
