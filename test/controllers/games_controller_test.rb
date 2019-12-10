require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test 'cannot get summary before game is open' do
    games(:mitre_ctf_game).update_attributes(start: Time.now + 9.hours, stop: Time.now + 10.hours)

    get :summary
    assert_redirected_to @controller.user_root_path
    assert_equal flash[:alert], I18n.t('game.before_competition')
  end

  test "should get summary during game" do
    get :summary
    assert_response :success
  end

  test "should get summary after game" do
    games(:mitre_ctf_game).update_attributes(start: Time.now - 9.hours, stop: Time.now - 1.hours)

    get :summary
    assert_response :success
  end

  test 'guest and user cannot access resume' do
    user = add_resume_transcript_to(users(:user_four))
    assert_raises(ActiveRecord::RecordNotFound) do
      get :resumes # Nobody is signed in
    end
    sign_in user
    assert_raises(ActiveRecord::RecordNotFound) do
      get :resumes # User is signed in
    end
  end

  test 'admin can access resume' do
    user = add_resume_transcript_to(users(:user_four))
    sign_in users(:admin_user)
    get :resumes
    assert_response :success
    assert_equal "application/zip", response.content_type
  end

  test 'guest and user cannot access transcript' do
    user = add_resume_transcript_to(users(:user_four))
    assert_raises(ActiveRecord::RecordNotFound) do
      get :transcripts # Nobody is signed in
    end
    sign_in user
    assert_raises(ActiveRecord::RecordNotFound) do
      get :transcripts # User is signed in
    end
  end

  test 'guest and user cannot access show as markdown' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, format: :markdown # Nobody is signed in
    end
    sign_in users(:user_four)
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, format: :markdown # User is signed in
    end
  end

  test 'admin can access transcript' do
    user = add_resume_transcript_to(users(:user_four))
    sign_in users(:admin_user)
    get :transcripts
    assert_response :success
    assert_equal "application/zip", response.content_type
  end

  test 'admin can access show as markdown' do
    sign_in users(:admin_user)
    get :show, format: :markdown
    assert_response :success
    assert_equal "text/markdown", response.content_type
  end
end
