# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  before_action :load_game, :load_message_count, except: %i[new destroy]
  before_action :load_game_for_login, only: %i[new]

  def load_game_for_login
    @game = Game.instance
  end

  def new
    super
  end
end
