class JeopardyGame < Game
  with_options dependent: :destroy do
    has_many :categories, foreign_key: :game_id
    has_many :challenges, through: :categories
    has_many :divisions, foreign_key: 'game_id', class_name: 'PointDivision', inverse_of: :game
    has_many :teams, through: :divisions
    has_many :users, through: :teams
    has_many :feed_items, through: :divisions
    has_many :achievements, through: :divisions
    has_many :solved_challenges, class_name: 'PointSolvedChallenge', through: :divisions
  end

  alias :load_categories_or_teams :categories
end
