class StillCompeteForMoney < ActiveRecord::Migration[4.2]
  def change
  	add_column :users, :still_compete, :string, :limit => 2
  end
end
