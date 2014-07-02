class AddResumeToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :resume
  end
end
