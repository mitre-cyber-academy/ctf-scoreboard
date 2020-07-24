# frozen_string_literal: true

class SubmittedFlag < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  has_one :survey, dependent: :destroy

  validates :text, presence: true

  def self.create(attributes = nil, &block)
    if attributes[:challenge].is_a?(DefenseFlag)
      flag = attributes[:challenge]
      attributes.merge!(type: 'PentestSubmittedFlag', flag: flag, challenge: flag.challenge)
    end

    super
  end
end
