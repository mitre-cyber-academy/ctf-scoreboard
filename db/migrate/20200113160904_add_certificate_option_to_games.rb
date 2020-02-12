class AddCertificateOptionToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :enable_completion_certificates, :boolean, default: false
  end
end
