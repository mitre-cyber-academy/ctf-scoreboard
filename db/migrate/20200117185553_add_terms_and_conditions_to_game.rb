class AddTermsAndConditionsToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :terms_and_conditions, :text
  end
end
