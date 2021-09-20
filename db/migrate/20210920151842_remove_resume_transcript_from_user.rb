class RemoveResumeTranscriptFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :resume, :oid
    remove_column :users, :transcript, :oid
  end
end
