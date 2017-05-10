# frozen_string_literal: true

class GamesController < ApplicationController
  def show
    @game = Game.includes(:categories).includes(:challenges).instance
    @challenges = @game&.challenges
    @categories = @game&.categories
    @solved_challenges = current_user&.team&.solved_challenges.map(&:challenge_id)
  end

  def summary; end
end
