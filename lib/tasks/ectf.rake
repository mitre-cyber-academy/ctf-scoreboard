# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :ectf do
  desc 'Reset the game back to a clean state'
  task reset: %i[destructive environment] do
    Game.instance.destroy
  end

  desc 'Initialize a new Embedded CTF Game based on a game configuration file'
  task :initialize_game, [:game_settings_path] => [:environment] do |_task, args|
    settings = JSON.parse(File.read(args[:game_settings_path]))
    Game.create!(
      title: settings['game_name'],
      start: DateTime.strptime(settings['start_time'], settings['time_format_string']),
      stop: DateTime.strptime(settings['stop_time'], settings['time_format_string']),
      terms_of_service: '',
      board_layout: :teams_x_challenges,
      contact_email: 'ectf@mitre.org',
      description: settings['description']
    )

    Category.create!(game: game, name: 'Optional Implementation') if settings['optional_implementation_features']
  end

  desc 'Load teams for an Embedded CTF Game based on a teams configuration file'
  task :setup_teams, %i[teams_path] => [:environment] do |_task, args|
    teams = JSON.parse(File.read(args[:teams_path]))
    user_logins = []

    division = Division.create_with(game: Game.instance).find_or_create_by(name: 'Collegiate')

    teams.each do |team|
      password = Devise.friendly_token
      user_info = team.slice('state', 'affiliation', 'email').merge({
                                                                      full_name: team['team_name'],
                                                                      password: password,
                                                                      password_confirmation: password,
                                                                      year_in_school: 12,
                                                                      compete_for_prizes: true,
                                                                      confirmed_at: DateTime.now
                                                                    })
      user = User.create!(user_info)
      user_logins << user_info.slice('email', :password)

      Team.create!(team.slice('team_name', 'affiliation').merge({
                                                                  team_captain: user,
                                                                  division: division,
                                                                  eligible: true
                                                                }))
    end

    puts JSON.pretty_generate(user_logins)
  end

  desc 'Load design phase challenges for an Embedded CTF Game based on a configuration file'
  task :setup_design_phase, [:design_challenges_path] => [:environment] do |_task, args|
    design_challenges = JSON.parse(File.read(args[:design_challenges_path]))
    game = Game.instance
    design_category = Category.create_with(game: Game.instance).find_or_create_by(name: 'Design Phase')

    design_challenges.each do |name, attributes|
      challenge = StandardChallenge.create!(
        name: name,
        description: attributes['description'],
        point_value: attributes['points'],
        state: 'open',
        game: game,
        categories: [design_category]
      )
      attributes['values'].each do |flag|
        StandardFlag.create!(
          flag: flag,
          type: 'StandardFlag',
          challenge: challenge,
          start_calculation_at: game.start
        )
      end
    end
  end

  desc 'Load attack phase challenges for an Embedded CTF Game based on a configuration file'
  task :setup_attack_phase, %i[game_settings_path attack_challenges_path] => [:environment] do |_task, args|
    settings = JSON.parse(File.read(args[:game_settings_path]))
    challenges = JSON.parse(File.read(args[:attack_challenges_path]))
    game = Game.instance

    challenges.each do |name, _attributes|
      category = Category.create!(game: game, name: name)

      settings_values = settings.slice('point_value', 'first_capture_point_bonus')
      PentestChallenge.create!(
        settings_values.merge({
                                name: name,
                                initial_shares: settings['share_increment'],
                                solved_decrement_shares: settings['share_decrement'],
                                solved_decrement_period: settings['elapsed_time'],
                                unsolved_increment_period: settings['point_elapsed_time'],
                                defense_points: settings['defense_point_increment'],
                                defense_period: settings['defense_elapsed_time'],
                                state: 'closed',
                                description: 'Obtain the flag from the broadcasting device',
                                game: game,
                                categories: [category]
                              })
      )
    end
  end

  desc 'Add team to the attack phase'
  task :add_team_to_attack_phase, %i[team_display_name date_string] => [:environment] do |_task, args|
    game = Game.instance
    team = Team.find_by(team_name: args[:team_display_name])
    output = {}

    game.pentest_challenges.each do |challenge|
      challenge.update(state: :open)
      challenge_flag = "ectf{#{challenge.name.gsub(/\W/, '').downcase}_#{SecureRandom.hex}}"
      DefenseFlag.create!(
        flag: challenge_flag,
        type: 'DefenseFlag',
        challenge: challenge,
        team: team,
        start_calculation_at: DateTime.strptime(args[:date_string], '%Y-%m-%d %H:%M:%S')
      )
      output[challenge.name] = challenge_flag
    end

    puts JSON.pretty_generate(output)
  end
end

task destructive: :environment do
  print 'This task is destructive! Are you sure you want to continue? [y/N] '
  input = $stdin.gets.chomp
  raise unless input.downcase == 'y'
end
# rubocop:enable Metrics/BlockLength
