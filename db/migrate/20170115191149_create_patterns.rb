class CreatePatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :patterns do |t|
    	t.belongs_to :category, index: true, foreign_key: true
      t.string :name
      t.integer :frequency
      t.date :last_activity
      t.date :next_activity
      t.decimal :last_amount

      t.timestamps
    end
    
    create_table :patterns_origins, id: false do |t|
    	t.belongs_to :pattern, index: true, foreign_key: true
    	t.belongs_to :origin, index: true, foreign_key: true
    end
  end
end
