class CreateUserInvites < ActiveRecord::Migration
  def change
    create_table :user_invites do |t|
      t.string :email
      t.references :team, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
