# frozen_string_literal: true

class GamesController < ApplicationController
  def show
    @game = Game.includes(:categories).includes(:challenges).instance
    @challenges = @game&.challenges
    @categories = @game&.categories
    @solved_challenges = current_user&.team&.solved_challenges
  end

  def index
    @game = Game.instance
    @categories = @game.categories.includes(:challenges).order(:name)
    @challenges = @game.challenges
    @divisions = @game.divisions
    # Only exists for the purpose of providing an active tab for admins.
    @active_division = @divisions.first
  end

  def summary; end
end
