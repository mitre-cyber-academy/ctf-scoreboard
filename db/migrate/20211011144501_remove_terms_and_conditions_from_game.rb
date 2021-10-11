class RemoveTermsAndConditionsFromGame < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :terms_and_conditions, :text
  end
end
