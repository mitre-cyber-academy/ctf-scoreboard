class RemoveCategoryIdFromChallenges < ActiveRecord::Migration[5.1]
  def change
    remove_column :challenges, :category_id, :int4
  end
end
