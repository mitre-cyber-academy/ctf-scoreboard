class AddToggleRegistration < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :registration_enabled, :boolean, default: true, null: false
  end
end
