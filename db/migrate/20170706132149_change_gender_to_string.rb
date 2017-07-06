class ChangeGenderToString < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :gender, :string
    User.all.each do |user|
      if user.gender == '0'
        user.update(gender: 'Male')
      end
      if user.gender == '1'
        user.update(gender: 'Female')
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
