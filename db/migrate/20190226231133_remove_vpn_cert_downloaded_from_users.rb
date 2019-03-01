class RemoveVpnCertDownloadedFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :vpn_cert_downloaded, :boolean
  end
end
