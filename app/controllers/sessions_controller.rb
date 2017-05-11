class SessionsController < Devise::SessionsController
  before_action :load_game
end
