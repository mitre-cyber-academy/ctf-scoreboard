class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.integer :difficulty, default: 0, null: false
      t.integer :realism, default: 0, null: false
      t.integer :interest, default: 0, null: false
      t.text :comment, default: "", null: true
      t.integer :submitted_flag_id, null: false
      t.timestamps
    end
    add_foreign_key "surveys", "submitted_flags"
  end
end
