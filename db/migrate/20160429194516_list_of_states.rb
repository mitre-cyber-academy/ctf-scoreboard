class ListOfStates < ActiveRecord::Migration
  def change
  	add_column :users, :state, :string, :limit => 1
  end
end
