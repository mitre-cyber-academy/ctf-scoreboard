class AddCompletionCertificateToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :completion_certificate_template, :oid
  end
end
