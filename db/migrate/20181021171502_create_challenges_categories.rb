class CreateChallengesCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :challenges_categories, primary_key: ["challenge_id", "category_id"], force: :cascade do |t|
      #t.references :challenges_categories, :challenge, foreign_key: {to_table: :challenges}
      #t.references :challenges_categories, :category, foreign_key: {to_table: :categories}
      t.integer :challenge_id, null: false
      t.integer :category_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
