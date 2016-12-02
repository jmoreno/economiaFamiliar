class AddNewFieldsToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :card, :string
    add_column :activities, :concept, :string
    add_column :activities, :commission, :decimal
    add_column :activities, :reference, :string
    add_column :activities, :command, :string
  end
end
