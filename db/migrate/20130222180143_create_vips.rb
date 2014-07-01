class CreateVips < ActiveRecord::Migration
  def change
    create_table :vips do |t|
      t.string :name
      t.string :email
      t.string :company

      t.timestamps
    end
  end
end
