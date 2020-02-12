class AddEmailToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :do_not_reply_email, :string
    add_column :games, :contact_email, :string
  end
end
