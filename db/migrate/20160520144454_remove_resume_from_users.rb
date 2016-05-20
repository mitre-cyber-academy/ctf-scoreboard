class RemoveResumeFromUsers < ActiveRecord::Migration
  def change
    remove_attachment :users, :resume
  end
end
