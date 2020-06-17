class AddSponsorLogo < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :sponsor_logo, :text, default: '', :null => false
    add_column :challenges, :sponsor_description, :text, default: '', :null => false
  end
end
