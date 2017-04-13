class CreateGames < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.string :name
      t.datetime :start
      t.datetime :stop
      t.text :description
      t.text :terms_of_service
      t.string :irc
      t.boolean :disable_vpn
      t.boolean :disable_flags_an_hour_graph, default: false

      t.timestamps null: false
    end
  end
end
