class AddResumeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_attachment :users, :resume
  end

  # def prevent_spoofing
  # 	add_attachment :avatar
  # 	add_attachment :avatar, :matches => [/pdf\Z/, /docx\Z/]
  # 	add_attachment :avatar
  # end
end
