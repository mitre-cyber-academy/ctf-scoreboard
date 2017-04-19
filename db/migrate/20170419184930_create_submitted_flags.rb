class CreateSubmittedFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :submitted_flags do |t|
      t.integer :challenge_id
      t.integer :user_id
      t.string :text
    end
  end
end
