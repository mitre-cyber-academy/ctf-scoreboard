class AddConfirmationtokenToVips < ActiveRecord::Migration
  def change
    add_column :vips, :confirmation_token, :string
  end
end
