require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user_in_school = User.create!(
      full_name: 'User one',
      email: 'user4@test.com',
      affiliation: 'School',
      year_in_school: 12,
      state: 'FL',
      password: 'TestPassword123'
    )
    @user_out_of_school = User.create!(
      full_name: 'User two',
      email: 'user5@test.com',
      affiliation: 'Out of School',
      year_in_school: 0,
      state: 'FL',
      password: 'TestPassword123',
      compete_for_prizes: true
    )
    @user_out_of_state = User.create!(
      full_name: 'User two',
      email: 'user6@test.com',
      affiliation: 'Out of School',
      year_in_school: 12,
      state: 'NA',
      password: 'TestPassword123',
      compete_for_prizes: true
    )
  end

  test 'default compete for prizes value is false if none is provided' do
    assert_equal(false, @user_in_school.compete_for_prizes)
  end

  test 'user must be in school to compete for prizes' do
    assert_equal(false, @user_out_of_school.compete_for_prizes)
  end

  test 'user must be in the US to compete for prizes' do
    assert_equal(false, @user_out_of_state.compete_for_prizes)
  end

  test 'user previously not in the US can compete for prizes' do
    @user_out_of_state.state = 'FL'
    @user_out_of_state.compete_for_prizes = true
    assert @user_out_of_state.save
    assert_equal(true, @user_out_of_state.compete_for_prizes)
  end

  test 'user is a team captain' do
    assert_equal(true, users(:user_one).team_captain?)
    assert_equal(false, users(:user_two).team_captain?)
  end

  test 'user can promote a a team captain if they are currently captain' do
    team_captain = users(:full_team_user_one)
    user_on_team = users(:full_team_user_two)
    assert_equal(true, team_captain.can_promote?(user_on_team))
  end

  test 'team captain cannot promote themselves team captain' do
    team_captain = users(:full_team_user_one)
    assert_equal(false, team_captain.can_promote?(team_captain))
  end

  test 'non team captain cannot promote a team captain' do
    user_on_team = users(:full_team_user_two)
    another_user = users(:full_team_user_three)
    assert_equal(false, user_on_team.can_promote?(another_user))
  end

  test 'team captain can remove themselves from a team' do
    team_captain = users(:full_team_user_one)
    assert_equal(true, team_captain.can_remove?(team_captain))
  end

  test 'team captain can remove a member from his team' do
    team_captain = users(:full_team_user_one)
    user_on_team = users(:full_team_user_two)
    assert_equal(true, team_captain.can_remove?(user_on_team))
  end

  test 'user can remove themselves from a team' do
    user_on_team = users(:full_team_user_two)
    assert_equal(true, user_on_team.can_remove?(user_on_team))
  end

  test 'non team captain cannot remove another user from a team' do
    user_on_team = users(:full_team_user_two)
    another_user = users(:full_team_user_three)
    assert_equal(false, user_on_team.can_remove?(another_user))
  end

  test 'cert file name is property created' do
    cert_file_name = users(:user_one).full_name.tr('^A-Za-z', '')[0..10] + users(:user_one).id.to_s
    assert_equal cert_file_name, users(:user_one).vpn_cert_file_name
  end

  test 'admin cert filename is not broken if the admin has no name on file' do
    admin = users(:admin_user)
    admin.save
    assert_equal admin.id.to_s, admin.vpn_cert_file_name
  end

  test 'users certificate is properly created' do
    user = users(:user_one)
    user.save
    assert user.vpn_cert_request_created?
    # The VPN certificate creation is all handled by the VPN server, here we workaround
    # the fact that there is no VPN server in the test environment by saving the user and
    # then calling the certificate creation method with the .zip extension. This will trigger
    # the code to believe that the VPN server responded to the certificate request, however
    # the "certificate" that is created is simply going to be an empty file
    VpnModule::S3Certificates.instance.create_certificate_for("#{user.vpn_cert_file_name}.zip")
    assert_not_nil user.vpn_cert_url
  end

  test 'users country is calculated on save' do
    # Users current_sign_in_ip is set to a US held IP
    user = users(:full_team_user_one)
    user.save
    assert user.geocoded?
    assert_equal 'United States', user.country
  end

  test 'transform replaces bad characters' do
    assert_equal 'abcs_123_', (ApplicationRecord.transform'@Bc$_#123!%^&*()] [/\\')
  end
end
