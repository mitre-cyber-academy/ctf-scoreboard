# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  before_action :load_game
end
