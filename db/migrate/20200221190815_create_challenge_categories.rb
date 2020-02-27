class CreateChallengeCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_categories do |t|
      t.references :category, foreign_key: true
      t.references :challenge, foreign_key: true
    end
  end
end
