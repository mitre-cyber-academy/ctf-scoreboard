class AddCustomCongratTextToFlags < ActiveRecord::Migration[6.0]
  def change
    add_column :flags, :custom_congrat_text, :string
  end
end
