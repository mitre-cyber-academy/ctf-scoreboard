class RemoveDisableVpnFromGame < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :disable_vpn, :boolean
  end
end
