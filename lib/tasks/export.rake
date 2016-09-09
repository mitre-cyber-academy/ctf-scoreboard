namespace :export do
  desc "Exports players to the scoreboard and sends all players an email containing their login information."
  task players_to_scoreboard: :environment do
    puts %[puts 'Rails console commands follow:']
    puts %[game = Game.first]
    puts %[high_school = Division.create!(name: 'High School', game: game)]
    puts %[college = Division.create!(name: 'College', game: game)]
    puts %[professional = Division.create!(name: 'Professional', game: game)]
    Team.all.each do |team|
      team_username = team.scoreboard_login_name
      team_passwd = SecureRandom.uuid.delete("-")[0..32]
      division = team.division_level.downcase.tr(" ", "_")
      puts %[player = game.players.new]
      puts %[player.email = "#{team_username}"]
      puts %[player.display_name = "#{team.team_name}"]
      puts %[player.password = "#{team_passwd}"]
      puts %[player.division = #{division}]
      puts %[player.eligible = #{team.eligible_for_prizes?}]
      puts %[player.affiliation = "#{team.affiliation}"]
      puts %[player.city = "#{team.common_team_location}"]
      puts %[player.save]
      UserMailer.send_credentials(team, team_username, team_passwd).deliver_now
    end
  end

end
