class Page < ApplicationRecord
  belongs_to :game

  validates :path, presence: true, uniqueness: { scope: :game_id }, :format => { with: /\A[a-zA-Z\-]*\z/ , :message => 'path can only consist of letters and dashes' }
end
