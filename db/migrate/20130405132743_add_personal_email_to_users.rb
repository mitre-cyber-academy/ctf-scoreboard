class AddPersonalEmailToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :personal_email, :string
  end
end
