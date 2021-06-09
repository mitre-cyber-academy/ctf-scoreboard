require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  def setup
    @game = create(:active_game)
  end

  test 'unauthenticated users should not be able to access new team page' do
    get :new
    assert_redirected_to root_path
  end

  test 'unauthenticated users should not be able to access team show page' do
    get :show, params: { id: create(:team) }
    assert_redirected_to root_path
  end

  test 'unauthenticated users should not be able to access team edit page' do
    get :edit, params: { id: create(:team) }
    assert_redirected_to root_path
  end

  test 'team captain should be able to access team edit page' do
    user = create(:user_with_team)
    sign_in user
    get :edit, params: { id: user.team }
    assert_response :success
    assert_select 'h1', /Edit your Team/
    assert_select "legend", "New Team Information"
  end

  test 'authenticated users with no team should be able to access new team page' do
    sign_in create(:user)
    get :new
    assert_response :success
  end

  test 'authenticated users with a team should not be able to access new team page' do
    user = create(:user_with_team)
    sign_in user
    get :new
    assert_redirected_to team_path(user.team)
    assert_equal I18n.t('teams.already_on_team_create'), flash[:alert]
  end

  test 'authenticated users with a team can view their team' do
    user = create(:user_with_team)
    sign_in user
    get :show, params: { id: user.team }
    assert_response :success
  end

  test 'authenticated users with a team cannot edit their team unless they are a team captain' do
    user_not_captain = create(:user, team: create(:team))
    sign_in user_not_captain
    get :edit, params: { id: user_not_captain.team }
    assert_redirected_to @controller.user_root_path
    assert I18n.t('teams.must_be_team_captain'), flash[:alert]
  end

  test 'users cannot view other teams management' do
    user = create(:user)
    sign_in user
    get :show, params: { id: create(:team) }
    assert_redirected_to @controller.user_root_path
  end

  test 'members of a team can view their team management' do
    user = create(:user_with_team)
    sign_in user
    get :show, params: { id: user.team }
    assert_response :success
    assert_select "h4", "Team Prize Eligibility Status"
    assert_select "h4", "Team Division Status"
    assert_select "h3", "Pending User Invites"
    assert_select "h4", "Invite a Team Member"
  end

  test 'authenticated users without a team cannot view teams show page' do
    user = create(:user)

    sign_in user
    get :show, params: { id: create(:team) }
    assert_redirected_to @controller.user_root_path
    assert_equal I18n.t('teams.invalid_permissions'), flash[:alert]
  end

  test 'authenticated users without a team can view teams summary page' do
    user = create(:user)
    sign_in user
    team = create(:team)
    get :summary, params: { id: team }
    assert_response :success
    assert_select 'h3', 'Team Flag Submissions'
    assert_select 'h3', 'Solved Challenges'
    assert_select 'h3', pluralize(team.solved_challenges.size, 'solved challenge')
  end

  test 'team summary page correctly redirects if the team does not exist' do
    get :summary, params: { id: '9999999999999' }
    assert_redirected_to game_summary_path
    assert_equal I18n.t('teams.does_not_exist'), flash[:alert]
  end

  test 'a team cannot be created with the same name as another team' do
    team = create(:team)
    sign_in create(:user)
    assert_no_difference 'Team.count', 'A Team should not be created' do
      post :create, params: { team: { team_name: team.team_name, affiliation: 'school1', division_id: create(:hs_division) } }
    end
    assert_redirected_to new_team_path
    assert_includes flash[:alert], 'Team name has already been taken'
  end

  test 'authenticated users with a team should not be able to create new team' do
    user = create(:user_with_team)
    sign_in user
    assert_no_difference 'Team.count', 'A Team should not be created' do
      post :create, params: { team: { team_name: 'random_team_name', affiliation: 'school1', division_id: create(:hs_division) } }
    end
    assert_redirected_to team_path(user.team)
    assert_equal I18n.t('teams.already_on_team_create'), flash[:alert]
  end

  test 'a team cannot be created with the same name as another team in any case' do
    team = create(:team)
    sign_in create(:user)

    assert_no_difference 'Team.count', 'A Team should not be created' do
      post :create, params: { team: { team_name: team.team_name.upcase, affiliation: 'school1', division_id: create(:hs_division) } }
    end
    assert_redirected_to new_team_path
    assert_includes flash[:alert], 'Team name has already been taken'
  end

  test 'a team can be created by a user not currently on a team and the current user will be set as the team captain' do
    user = create(:user)
    sign_in user
    assert_difference 'Team.count' do
      post :create, params: { team: { team_name: 'another_team', affiliation: 'school1', division_id: create(:hs_division) } }
    end
    assert_redirected_to team_path(user.reload.team)
    assert_equal user.team.team_captain, user
  end

  test 'a team captain of a full team sees a message informing them that their team is full' do
    team = create(:team, additional_member_count: @game.team_size - 1)
    user = team.team_captain
    sign_in user
    get :show, params: { id: team }
    assert_equal flash[:notice], I18n.t('teams.full_team')
  end

  test 'a team member of a full team sees a message informing them that their team is full' do
    user_not_captain = create(:user, team: create(:team, additional_member_count: @game.team_size - 2))
    sign_in user_not_captain
    get :show, params: { id: user_not_captain.team }
    assert_equal flash[:notice], I18n.t('teams.full_team')
  end

  test 'a team captain of a non-full team does not see a message stating that their team is full' do
    user = create(:user_with_team)
    sign_in user
    get :show, params: { id: user.team }
    assert_not_equal flash[:notice], I18n.t('teams.full_team')
  end

  test 'invite a team member' do
    user = create(:user_with_team)
    sign_in user
    assert_difference 'user.team.user_invites.count', +1, 'A user invite should be created' do
      patch :invite, params: { team: { user_invites_attributes: { '0': {email: 'mitrectf+user3@gmail.com'} } }, id: user.team }
    end
    assert I18n.t('invites.invite_successful'), flash[:notice]
    assert_redirected_to team_path(user.team)
  end

  test 'invite a team member who has already been invited' do
    user = create(:user_with_team)
    email_to_invite = 'mitrectf+user2@gmail.com'
    create(:point_user_invite, email: email_to_invite, team: user.team)
    sign_in user
    assert_no_difference 'user.team.user_invites.count', 'A user invite should not be created' do
      patch :invite, params: { team: { user_invites_attributes: { '0': {email: email_to_invite}} }, id: user.team }
    end
    assert I18n.t('en.activerecord.errors.models.user_invite.attributes.email.uniqueness'), flash[:alert]
    assert_redirected_to team_path(user.team)
  end

  test 'update a team when game is open and team is not in top ten' do
    user = create(:user_with_team)
    sign_in user
    patch :update, params: { team: { team_name: 'team_one_newname', affiliation: 'school1', looking_for_members: false }, id: user.team }
    assert I18n.t('teams.update_successful'), flash[:notice]
    assert_redirected_to team_path(user.team)
  end

  test 'update a team without permission' do
    team = create(:team)
    user = create(:user_with_team)
    sign_in user
    patch :update, params: { team: { team_name: 'team_one_newname', affiliation: 'school1', looking_for_members: false }, id: team }
    assert I18n.t('teams.invalid_permissions'), flash[:alert]
    assert_redirected_to @controller.user_root_path
  end

  test 'team captain can not send invites while in top ten' do
    team = create(:team_in_top_ten_standard_challenges)
    sign_in team.team_captain
    patch :invite, params: { team: { user_invites_attributes: { '0': {email: 'mitrectfnewuserfake@mail.google.com'}}}, id: team}
    assert_equal I18n.t('teams.in_top_ten'), flash[:alert]
    assert_redirected_to @controller.user_root_path
  end

  test 'can not update team when game is open and team is in top ten' do
    team = create(:team_in_top_ten_standard_challenges)
    old_data = team.affiliation
    sign_in team.team_captain

    patch :update, params: { team: { team_name: 'team_three_newname', affiliation: 'i do not know' }, id: team }
    assert_equal old_data, team.affiliation
    assert_equal I18n.t('teams.in_top_ten'), flash[:alert]
    assert_redirected_to @controller.user_root_path
  end

  test "solved challenges table displays correctly with 0 solved challenges" do
    user = create(:user_with_team)
    StandardSolvedChallenge.destroy_all
    create_list(:standard_challenge, 0, team: user.team)
    sign_in user
    get :show, params: { id: user.team }
    assert_response :success
    assert_select "div.zero-items-text", {:count=>4, :text=>"Nothing to report"}, "Nothing to Report text is missing"
  end

  [1, 3, 5, 6].each do |challenge_count|
    test "solved challenges table displays correctly with #{challenge_count} solved challenges" do
      user = create(:user_with_team)
      sign_in user
      StandardSolvedChallenge.destroy_all
      create_list(:standard_solved_challenge, challenge_count, team: user.team)
      get :show, params: { id: user.team }
      assert_response :success
      assert_select 'tbody' do
        StandardSolvedChallenge.all.each do |sc|
          assert_select 'tr' do
            assert_select 'td', "#{sc.challenge.name}", "Solved Challenge name missing from team's solved challenges table"
            assert_select 'td', "#{sc.challenge.display_point_value(user.team)}", "Solved Challenge point value missing from team's solved challnges table"
            assert_select 'td', "#{sc.created_at.strftime('%B %e at %l:%M %p %Z')}", "Solved Challenge time missing from team's solved challenges table"
          end
        end
      end
    end
  end

  test "solved challenges table show button displays when num solved challenges is greater than 5" do
    user = create(:user_with_team)
    sign_in user
    StandardSolvedChallenge.destroy_all
    create_list(:standard_solved_challenge, 6, team: user.team)
    get :show, params: { id: user.team }
    assert_response :success
    if user.team.solved_challenges.size > 5
      assert_select 'tr#showBtnRow' do
        assert_select 'td' do
          assert_select 'a.toggler', I18n.t('teams.summary.solved_challenges_table.show_hide_btn'), "Show/Hide button missing from Solved Challenges table"
        end
      end
    end
  end

  test 'update a team when game is closed' do
    create(:unstarted_game)
    user = create(:user_with_team)
    sign_in user
    patch :update, params: { team: { team_name: 'team_one_newname', affiliation: 'school1' }, id: user.team }
    assert I18n.t('teams.update_successful'), flash[:notice]
    assert_redirected_to team_path(user.team)
  end

  test 'can not update a team after game is closed' do
    create(:ended_game)
    user = create(:user_with_team)
    sign_in user
    patch :update, params: { team: { team_name: 'team_one_newname', affiliation: 'school1' }, id: user.team }
    assert_equal I18n.t('game.after_competition'), flash[:alert]
    assert_redirected_to @controller.user_root_path
  end

  test 'update a team with invalid params' do
    team = create(:team)
    sign_in team.users.first
    patch :update, params: { team: { team_name: 'hell'}, id: team }
    assert_includes flash[:alert], 'profane'
    assert_redirected_to edit_team_path(team)
  end

  test 'cannot create a team after game is closed' do
    create(:ended_game)
    user = create(:user)
    sign_in user
    assert_no_difference 'Team.count' do
      post :create, params: { team: { team_name: 'another_team', affiliation: 'school1', division_id: create(:hs_division) } }
    end
    assert I18n.t('game.after_competition'), flash[:alert]
    assert_redirected_to @controller.user_root_path
  end

  test 'cannot invite a team member after game is closed' do
    create(:ended_game)
    user = create(:user_with_team)
    sign_in user
    assert_no_difference 'user.team.user_invites.count' do
      patch :invite, params: { team: { user_invites_attributes: { '0': {email: 'mitrectf+user3@gmail.com'} } }, id: user.team }
    end
    assert I18n.t('game.after_competition'), flash[:alert]
    assert_redirected_to @controller.user_root_path
  end

  test 'show team after game is closed' do
    create(:ended_game)
    user = create(:user_with_team)
    sign_in user
    get :show, params: { id: user.team }
    assert_response :success
  end

  test 'summary is available after game is closed' do
    create(:ended_game)
    team = create(:team)
    get :summary, params: { id: team }
    assert_response :success
    assert_select 'h3', 'Team Flag Submissions'
    assert_select 'h3', 'Solved Challenges'
    assert_select 'h3', pluralize(team.solved_challenges.size, 'solved challenge')
    assert_select 'h3', {count: 0, text: 'Team Members'}, 'Team member list should only be visible to administrators'
    assert_select 'h3', {count: 0, text: 'Per User Statistics'}, 'Per User Statistics should only be visible to administrators'
  end

  test 'summary page shows additional information to administrators' do
    create(:ended_game)
    admin = create(:admin)
    sign_in admin
    team = create(:team)
    get :summary, params: { id: team }
    assert_response :success
    assert_select 'h3', 'Team Flag Submissions'
    assert_select 'h3', 'Solved Challenges'
    assert_select 'h3', pluralize(team.solved_challenges.size, 'solved challenge')
    assert_select 'h3', 'Team Members'
    assert_select 'h3', 'Per User Statistics'
  end

  test 'edit a teams location' do
    user = create(:user_with_team) 
    sign_in user 
    patch :update, params: { team: {team_location: 'location' }, id: user.team } 
    assert_redirected_to team_path(user.team) 
    assert 'location', user.team.team_location
  end

  test 'summary pentest game' do
    Game.first.destroy
    create(:active_game)
    team = create(:team)
    captain = team.team_captain
    sign_in captain
    get :summary, params: { id: captain.team }
    assert_response :success
  end
end
