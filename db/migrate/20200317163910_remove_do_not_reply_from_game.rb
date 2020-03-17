class RemoveDoNotReplyFromGame < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :do_not_reply_email
  end
end
