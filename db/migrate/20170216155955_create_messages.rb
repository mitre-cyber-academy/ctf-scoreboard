class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :game_id
      t.text :text
      t.title :string
      t.string :title

      t.timestamps null: false
    end
  end
end
