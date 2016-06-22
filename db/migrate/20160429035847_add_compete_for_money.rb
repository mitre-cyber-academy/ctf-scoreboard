class AddCompeteForMoney < ActiveRecord::Migration
  def change
  	add_column :users, :play_for_money, :string, :limit => 2
  	#add_column :users, :no_play_for_money, :string, :limit => 2
  	#add_column :users, :still_compete, :string, :limit => 2
  end
end
