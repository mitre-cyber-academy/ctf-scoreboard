class ListOfStates < ActiveRecord::Migration[4.2]
  def change
  	add_column :users, :state, :string, :limit => 1
  end
end
