# frozen_string_literal: true

class FileSubmissionsController < ApplicationController
  include ApplicationModule

  before_action :deny_if_not_admin, :fetch_file_submission_by_id,
                only: %i[submitted_bundle fetch_file_submission_challenge_by_id`]
  before_action :deny_if_not_admin, :fetch_file_submission_challenge_by_id, only: %i[submitted_bundle fet]

  def submitted_bundle
    download_file(@file_submission.submitted_bundle, @file_submission_challenge.name)
  end

  private

  def fetch_file_submission_by_id
    @file_submission = FileSubmission.find_by(id: params[:id].to_i)
  end

  def fetch_file_submission_challenge_by_id
    @file_submission_challenge = Challenge.find_by(id: @file_submission.challenge_id)
  end
end
