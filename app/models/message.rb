class Message < ActiveRecord::Base
  belongs_to :game

  validates :text, :title, presence: true
end
