class RenameSubtitleToOrganization < ActiveRecord::Migration[5.2]
  def change
    change_table :games do |t|
      t.rename :subtitle, :organization
    end
  end
end
