class AddEmailMessageToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :email_message, :boolean, default: false
  end
end
