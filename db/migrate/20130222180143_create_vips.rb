class CreateVips < ActiveRecord::Migration[4.2]
  def change
    create_table :vips do |t|
      t.string :name
      t.string :email
      t.string :company

      t.timestamps
    end
  end
end
