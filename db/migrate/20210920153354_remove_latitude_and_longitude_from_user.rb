class RemoveLatitudeAndLongitudeFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :latitude, :float
    remove_column :users, :longitude, :float
  end
end
