class AddConfirmationtokenToVips < ActiveRecord::Migration[4.2]
  def change
    add_column :vips, :confirmation_token, :string
  end
end
