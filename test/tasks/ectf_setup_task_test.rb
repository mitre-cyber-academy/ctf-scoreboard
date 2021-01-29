require 'test_helper'
require 'rake'

class EctfSetupRakeTask < ActiveSupport::TestCase
  CtfRegistration::Application.load_tasks

  setup do
    Game.destroy_all
  end

  test 'initialize game rake task sets up an ECTF Game based on a configuration file' do
    assert_difference 'Game.count', +1 do
      Rake::Task["ectf:initialize_game"].execute(game_settings_path: 'test/files/ectf/settings.json')
    end
  end

  test 'the reset task clears all tables' do
    create(:active_game)
    create(:standard_challenge, flag_count: 3)
    create(:pentest_challenge_with_flags)
    create(:team, additional_member_count: 2)

    Rake::Task["ectf:reset"].execute

    ApplicationRecord.descendants.each do |model|
      assert_equal 0, model.count
    end
  end

  test 'setup teams rake task properly loads teams for an ECTF Game and prints the result' do
    # Game must be setup before running this task
    Rake::Task["ectf:initialize_game"].execute(game_settings_path: 'test/files/ectf/settings.json')

    assert_difference 'Team.count', +2 do
      assert_difference 'User.count', +2 do
        result = capture_stdout { Rake::Task["ectf:setup_teams"].execute(teams_path: 'test/files/ectf/teams.json') }
        output = JSON.parse(result[:stdout])

        assert_equal User.count, output.count
        assert_equal ['email', 'password'], output.first.keys
      end
    end
  end

  test 'setup design phase challenges rake task properly creates the appropriate number of design phase challenges' do
    # Game must be setup before running this task
    Rake::Task["ectf:initialize_game"].execute(game_settings_path: 'test/files/ectf/settings.json')

    assert_difference 'StandardChallenge.count', +4 do
      assert_difference 'StandardFlag.count', +4 do
        Rake::Task["ectf:setup_design_phase"].execute(design_challenges_path: 'test/files/ectf/design_phase_challenges.json')
      end
    end
  end

  test 'setup attack phase challenges rake task properly creates the appropriate number of attack phase challenges' do
    # Game must be setup before running this task
    Rake::Task["ectf:initialize_game"].execute(game_settings_path: 'test/files/ectf/settings.json')

    assert_difference 'Category.count', +6 do
      assert_difference 'PentestChallenge.count', +6 do
        Rake::Task["ectf:setup_attack_phase"].execute(game_settings_path: 'test/files/ectf/settings.json', attack_challenges_path: 'test/files/ectf/challenges.json')
      end
    end
  end

  test 'add team to attack phase properly sets up flags for the provided team name' do
    # Game must be setup before running this task
    Rake::Task["ectf:initialize_game"].execute(game_settings_path: 'test/files/ectf/settings.json')
    # Teams must be setup before running this task
    capture_stdout { Rake::Task["ectf:setup_teams"].execute(game_settings_path: 'test/files/ectf/settings.json', teams_path: 'test/files/ectf/teams.json') }
    # Attack phase challenges must be seeded before running this task
    Rake::Task["ectf:setup_attack_phase"].execute(game_settings_path: 'test/files/ectf/settings.json', attack_challenges_path: 'test/files/ectf/challenges.json')

    assert_difference 'DefenseFlag.count', +6 do
      result = capture_stdout { Rake::Task['ectf:add_team_to_attack_phase'].execute(team_display_name: 'Team Clare', date_string: '2020-06-19 00:28:00') }

      output = JSON.parse(result[:stdout])
      assert_equal 6, output.length
      assert_equal PentestChallenge.all.pluck(:name), output.keys
    end
  end
end
