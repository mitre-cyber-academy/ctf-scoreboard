class CreateFileSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :file_submissions do |t|
      t.bigint :challenge_id, null: false
      t.bigint :user_id, null: false
      t.oid :submitted_bundle, null: false
      t.text :description, default: "", null: false
      t.boolean :demoed, default: false, null: false

      t.timestamps
    end
    add_foreign_key "file_submissions", "challenges"
    add_foreign_key "file_submissions", "users"
  end
end
