class RemoveStillCompeteFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_attachment :users, :still_compete
  end
end
