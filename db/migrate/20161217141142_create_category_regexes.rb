class CreateCategoryRegexes < ActiveRecord::Migration[5.0]
  def change
    create_table :category_regexes do |t|
      t.string :regex
      t.string :category_name
      t.integer :origin
      t.integer :card
      t.integer :reference
      t.integer :concept
      t.integer :command

      t.timestamps
    end
  end
end
