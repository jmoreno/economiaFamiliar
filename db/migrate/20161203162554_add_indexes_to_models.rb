class AddIndexesToModels < ActiveRecord::Migration[5.0]
  def change
  	add_index :accounts, :name 
  	add_index :categories, :name 
  	add_index :origins, :name 
  end
end
