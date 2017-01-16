class CreateOriginsPatternsTable < ActiveRecord::Migration[5.0]
  def change
  	drop_table :patterns_origins
  	
    create_table :origins_patterns, id: false do |t|
    	t.belongs_to :origin, index: true
    	t.belongs_to :pattern, index: true
    end
  end
end
