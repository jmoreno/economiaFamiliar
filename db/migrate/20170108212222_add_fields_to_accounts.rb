class AddFieldsToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :reference, :string
    add_column :accounts, :first_balance, :decimal
  end
end
