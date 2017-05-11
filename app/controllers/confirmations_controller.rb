class ConfirmationsController < Devise::ConfirmationsController
  before_action :load_game
end
