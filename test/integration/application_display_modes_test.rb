require 'test_helper'

class ApplicationDisplayModesTest < ActionDispatch::IntegrationTest
  include TeamsHelper
  include Rails.application.routes.url_helpers
  include Devise::Test::IntegrationHelpers

  def setup
    @game = create(:game,
      title: 'Example Game',
      start: Time.now.utc - 5.days,
      stop: Time.now.utc + 5.days,
      description: 'Example Description',
      terms_of_service: 'Example ToS',
      terms_and_conditions: 'Example TAC',
      organization: 'Example Organization',
      contact_url: 'https://example.com',
      footer: 'Example Footer',
      team_size: 10,
      contact_email: 'example@example.com',
      open_source_url: 'https://github.com/mitre-cyber-academy/ctf-scoreboard',
      board_layout: 0
    )
  end

  test 'navigation bar shows all fields when logged out' do
    get root_path
    
    assert_select 'a[class=brand]', @game.organization, "Organization should show in navigation bar"
    assert_select "a[href=#{game_path.dump}]", I18n.t('application.navbar.challenges'), "Challenges should show in navigation bar"
    assert_select "a[href=#{game_messages_path.dump}]", I18n.t('application.navbar.messages'), "Messages should show in navigation bar"
    assert_select "a[href=#{game_achievements_path.dump}]", I18n.t('application.navbar.achievements'), "Achievements should show in navigation bar"
    assert_select "a[href=#{game_summary_path.dump}]", I18n.t('application.navbar.summary'), "Summary should show in navigation bar"
    assert_select "a[href=#{@game.contact_url.dump}]", I18n.t('application.navbar.contact'), "Contact should show in navigation bar if contact_url is defined in game"
    
    assert_select 'a[class=dropdown-toggle]', I18n.t('home.index.login_or_register'), "Log in / Register should show in navigation bar while not signed in"
    assert_select "a[href=#{new_user_session_path.dump}]", I18n.t('home.index.login'), "Login should show in navigation bar dropdown while not signed in"
    assert_select "a[href=#{new_user_registration_path.dump}]", I18n.t('home.index.register'), "Register should show in navigation bar dropdown while not signed in"
  end

  test 'navigation bar shows all fields for logged in user' do
    sign_in create(:user)
    get root_path

    assert_select "a[href=#{edit_user_registration_path.dump}]", I18n.t('application.edit_account'), "Edit account should show in navigation bar dropdown while signed in"
    assert_select "a[href=#{destroy_user_session_path.dump}]", I18n.t('application.log_out'), "Log out should show in navigation bar dropdown while signed in"
  end

  test 'navigation bar shows all fields when logged in with no team' do
    sign_in create(:user)
    get root_path

    assert_select "a[href=#{join_team_users_path.dump}]", I18n.t('home.index.join_team'), "Join team should show in navigation bar dropdown while signed in with no team"
    assert_select "a[href=#{new_team_path.dump}]", I18n.t('home.index.create_team'), "Create team should show in navigation bar dropdown while signed in with no team"
  end

  test 'navigation bar shows all fields when logged in with team' do
    team = create(:team, division: create(:hs_division))
    user = team.team_captain
    sign_in user
    get root_path

    assert_select "a[href=#{team_path(team.id).dump}]", I18n.t('home.index.view_team'), "View team should show in navigation bar dropdown while signed in with no team"
    assert_select "a[href=#{edit_team_path(team.id).dump}]", I18n.t('home.index.edit_team'), "Edit team should show in navigation bar dropdown while signed in with no team"
  end

  test 'game name shows on home page' do
    get root_path

    assert_select 'h1', /Example Game/, 'Game name should show on the home page'
    assert_select 'h2', /Competition in Progress/, 'Correct catchphrase should show on the home page'
    assert_select 'div[class=maincontent\ row-fluid\ indent-40px-left]' do
      assert_select 'p', /Example Description/, 'Game description should show on the home page' 
    end
    assert_select 'a[class=btn\ btn-large\ btn-primary]', I18n.t('home.index.register'), 'The register button should show on the home page while not logged in'
    assert_select 'footer[id=page-footer]' do
      assert_select 'p', /Example Footer/, 'Footer text should show in the footer'
    end
  end

  test 'Join/Create team buttons show when viewing homepage' do
    sign_in create(:user)
    get root_path

    assert_select 'a[class=btn\ btn-large\ btn-primary]', I18n.t('home.index.join_team')
    assert_select 'a[class=btn\ btn-large\ btn-primary]', I18n.t('home.index.create_team')

    team = create(:team, division: create(:hs_division))
    user = team.team_captain
    sign_in user
    get root_path

    assert_select 'a[class=btn\ btn-large\ btn-primary]', I18n.t('home.index.join_team')
  end
end
