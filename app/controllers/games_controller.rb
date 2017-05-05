# frozen_string_literal: true

class GamesController < ApplicationController
  def show
    @game = Game.instance
  end

  def summary; end
end
