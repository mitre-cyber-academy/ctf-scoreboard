# frozen_string_literal: true

class SubmittedFlag < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  validates :text, presence: true
end
