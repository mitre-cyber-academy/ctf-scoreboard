# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :game, required: true

  validates :text, :title, presence: true
end
