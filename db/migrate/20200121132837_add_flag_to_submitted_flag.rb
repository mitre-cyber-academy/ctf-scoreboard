class AddFlagToSubmittedFlag < ActiveRecord::Migration[5.2]
  def change
    add_reference :submitted_flags, :flag, foreign_key: true
  end
end
