class RemoveResumeFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_attachment :users, :resume
  end
end
