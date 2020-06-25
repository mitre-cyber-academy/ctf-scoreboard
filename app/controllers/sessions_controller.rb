# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  before_action :load_game, :load_message_count, except: %i[new destroy]
  before_action :define_game, only: %i[new]

  def define_game
    @game = Game.instance
  end
end
