class RemoveStillCompeteFromUsers < ActiveRecord::Migration
  def change
    remove_attachment :users, :still_compete
  end
end
