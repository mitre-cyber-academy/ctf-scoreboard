class AddResumeTranscriptToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :resume, :oid
    add_column :users, :transcript, :oid
  end
end
