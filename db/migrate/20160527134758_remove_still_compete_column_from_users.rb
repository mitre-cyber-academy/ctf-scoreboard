class RemoveStillCompeteColumnFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :still_compete
  end
end
