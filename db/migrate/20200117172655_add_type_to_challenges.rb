class AddTypeToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :type, :string
  end
end
