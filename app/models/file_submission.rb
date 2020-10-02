# frozen_string_literal: true

class FileSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  validates :submitted_bundle, presence: true

  mount_uploader :submitted_bundle, FileSubmissionUploader
end
