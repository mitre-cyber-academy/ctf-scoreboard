class CreateUserRequests < ActiveRecord::Migration
  def change
    create_table :user_requests do |t|
      t.boolean :pending
      t.references :team, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
