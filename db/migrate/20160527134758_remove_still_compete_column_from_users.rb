class RemoveStillCompeteColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :still_compete
  end
end
