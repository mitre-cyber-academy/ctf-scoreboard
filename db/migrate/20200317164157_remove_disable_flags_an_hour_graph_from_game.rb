class RemoveDisableFlagsAnHourGraphFromGame < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :disable_flags_an_hour_graph
  end
end
