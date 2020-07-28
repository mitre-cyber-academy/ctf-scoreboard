require 'test_helper'

class FileSubmissionsControllerTest < ActionController::TestCase

  def setup
    create(:active_game)
  end

  test 'guest and user cannot access file submissions' do
    user = create(:user)
    challenge = create(:file_submission_challenge)
    file_submission = create(:file_submission,
                              challenge_id: challenge.id,
                              user_id: user.id,
                              submitted_bundle: File.open(Rails.root.join('test/files/test_submission.zip')),
                              description: "Text",
                              demoed: false
                            )
    assert_raises(ActiveRecord::RecordNotFound) do
      get :submitted_bundle, params: { id: user.id } # Nobody is signed in
    end
    sign_in user
    assert_raises(ActiveRecord::RecordNotFound) do
      get :submitted_bundle, params: { id: user.id } # User is signed in
    end
  end

  test 'admin can access file submissions' do
    user = create(:user)
    challenge = create(:file_submission_challenge)
    file_submission = create(:file_submission,
                              challenge_id: challenge.id,
                              user_id: user.id,
                              submitted_bundle: File.open(Rails.root.join('test/files/test_submission.zip')),
                              description: "Text",
                              demoed: false
                            )
    sign_in create(:admin)
    get :submitted_bundle, params: { id: file_submission.id }
    assert_response :redirect
    assert_equal file_submission.submitted_bundle.url, request.original_fullpath
    assert_equal "text/html; charset=utf-8", response.content_type
  end
end
