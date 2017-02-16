class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :name
      t.text :description
      t.integer :point_value
      t.integer :starting_state
      t.integer :category_id
      t.string :achievement_name

      t.timestamps null: false
    end
  end
end
