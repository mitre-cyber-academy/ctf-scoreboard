class AddRefToChallengesCategories < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :challenges_categories, :challenges, column: :challenge_id
    add_foreign_key :challenges_categories, :categories, column: :category_id
  end
end
