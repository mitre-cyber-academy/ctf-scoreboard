require 'test_helper'

class FileSubmissionsControllerTest < ActionController::TestCase

  def setup
    create(:active_game)
  end

  test 'guest and user cannot access file submissions' do
    user = create(:user)
    challenge = create(:file_submission_challenge)
    file_submission = create(:file_submission)
    assert_raises(ActiveRecord::RecordNotFound) do
      get :submitted_bundle, params: { id: file_submission.id } # Nobody is signed in
    end
    sign_in user
    assert_raises(ActiveRecord::RecordNotFound) do
      get :submitted_bundle, params: { id: file_submission.id } # User is signed in
    end
  end

  test 'admin can access file submissions' do
    user = create(:user)
    challenge = create(:file_submission_challenge)
    file_submission = create(:file_submission)
    sign_in create(:admin)
    get :submitted_bundle, params: { id: file_submission.id }
    assert_response :success
    assert_equal file_submission.submitted_bundle.url, request.original_fullpath
    assert_equal "application/pdf", response.content_type
  end
end
