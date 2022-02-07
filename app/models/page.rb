class Page < ApplicationRecord
  belongs_to :game, optional: false


  validates :path, presence: true, uniqueness: { scope: :game_id, case_sensitive: false }, :format => { with: /\A[a-zA-Z\-]*\z/ , :message => 'path can only consist of letters and dashes' }
  before_save :downcase_path

  def preview
    self.body
  end

  def downcase_path
    self.path.downcase!
  end
end
