# frozen_string_literal: true

class AchievementsController < ApplicationController
  before_action :load_game, :load_message_count
  include ActionView::Helpers::TextHelper

  def index
    # Use created at becuase that's what the table is displaying in the view
    @achievements = @game.achievements.order(:updated_at).reverse_order
    @title = 'Achievements'
    @subtitle = pluralize(@achievements.size, 'achievement')
  end
end
