class RemoveIrcFromGame < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :irc
  end
end
