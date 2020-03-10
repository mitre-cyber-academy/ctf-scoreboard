require 'test_helper'

class GamesControllerTest < ActionController::TestCase

  def setup
    @game = create(:active_game, enable_completion_certificates: true)
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test 'cannot get summary before game is open' do
    create(:unstarted_game)

    get :summary
    assert_redirected_to @controller.user_root_path
    assert_equal flash[:alert], I18n.t('game.before_competition')
  end

  test "should get summary during game" do
    get :summary
    assert_response :success
  end

  test "should get summary after game" do
    create(:ended_game)

    get :summary
    assert_response :success
  end

  test 'guest and user cannot access resume unless they are an admin' do
    user = create(:user_with_resume)
    assert_raises(ActiveRecord::RecordNotFound) do
      get :resumes # Nobody is signed in
    end
    sign_in user
    assert_raises(ActiveRecord::RecordNotFound) do
      get :resumes # User is signed in
    end
  end

  test 'admin can access resume' do
    user = create(:user_with_resume)
    sign_in create(:admin)
    get :resumes
    assert_response :success
    assert_equal "application/zip", response.content_type
  end

  test 'guest and user cannot access transcript' do
    user = create(:user_with_resume)
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
    sign_in create(:user)
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, format: :markdown # User is signed in
    end
  end

  test 'admin can access transcript' do
    user = create(:user_with_resume)
    sign_in create(:admin)
    get :transcripts
    assert_response :success
    assert_equal "application/zip", response.content_type
  end

  test 'create zip of transcript' do
    user = create(:user_with_team)
    user.update(resume: File.open(Rails.root.join('test/files/regular.pdf')), transcript: File.open(Rails.root.join('test/files/regular.pdf')))
    sign_in create(:admin)
    get :transcripts
    assert_response :success
    assert_equal "application/zip", response.content_type
    # An empty zip (from the above test) is 22 byte so based on the test pdf...
    assert_operator response.body.size, :>, 1000

    get :resumes
    assert_response :success
    assert_equal "application/zip", response.content_type
    # An empty zip (from the above test) is 22 byte so based on the test pdf...
    assert_operator response.body.size, :>, 1000
  end

  test 'admin can access show as markdown' do
    sign_in create(:admin)
    get :show, format: :markdown
    assert_response :success
    assert_equal "text/markdown", response.content_type
  end

  test 'admin can access certificate template' do
    admin = create(:admin)
    sign_in admin
    get :completion_certificate_template
    assert_response :success
    assert_equal 'image/jpeg', response.content_type
  end

  test 'admin redirect when certificate template unavailable' do
    @game.destroy
    @game = create(:active_game)
    sign_in create(:admin)
    get :completion_certificate_template
    assert_redirected_to rails_admin_path
    assert_equal I18n.t('admin.download_not_available'), flash[:alert]
  end

  test 'show pentest game' do
    Game.first.destroy
    game = create(:active_game)
    create(:team_with_pentest_flags)
    get :show
    assert_response :success
  end

  [:jeopardy, :teams_x_challenges, :multiple_categories, :title_and_description].each do |board_layout|
    test "show #{board_layout} board layout" do
      create(:active_game, board_layout: board_layout)
      create_list(:standard_challenge, 3)
      create_list(:share_challenge, 3)
      get :show
      assert_response :success
    end
  end
end
