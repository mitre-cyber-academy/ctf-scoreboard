class AddVpnCertDownloadedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :vpn_cert_downloaded, :boolean, default: false
  end
end
