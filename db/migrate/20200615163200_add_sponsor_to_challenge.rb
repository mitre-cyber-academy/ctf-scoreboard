class AddSponsorToChallenge < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :sponsored, :boolean, default: false, null: false
    add_column :challenges, :sponsor, :text, default: ''
  end
end
