class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :account, index: true, foreign_key: true
      t.belongs_to :origin, index: true, foreign_key: true
      t.string :description
      t.date :operationDate
      t.date :valueDate
      t.decimal :amount
      t.decimal :balance

      t.timestamps
    end
  end
end
