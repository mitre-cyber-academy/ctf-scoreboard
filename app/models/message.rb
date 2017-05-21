# frozen_string_literal: true

class Message < ActiveRecord::Base
  belongs_to :game, required: true

  validates :text, :title, presence: true
end
