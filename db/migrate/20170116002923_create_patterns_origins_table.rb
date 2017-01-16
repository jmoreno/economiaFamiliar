class CreatePatternsOriginsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :patterns_origins, id: false do |t|
    	t.belongs_to :pattern, index: true, foreign_key: true
    	t.belongs_to :origin, index: true, foreign_key: true
    end
  end
end
