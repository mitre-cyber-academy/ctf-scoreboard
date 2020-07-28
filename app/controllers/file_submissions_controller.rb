# frozen_string_literal: true

class FileSubmissionsController < ApplicationController
  include ApplicationModule

  before_action :deny_if_not_admin, :fetch_file_submission_by_id, only: %i[submitted_bundle]

  def submitted_bundle
    @file_submission = FileSubmission.create
    @challenge = Challenge.create
    @file_submission.challenge_id = @challenge.name
    download_file(@file_submission.submitted_bundle, @file_submission.challenge_id)
  end

  private

  def fetch_file_submission_by_id
    @file_submission = FileSubmission.find_by(id: params[:id].to_i)
  end
end
