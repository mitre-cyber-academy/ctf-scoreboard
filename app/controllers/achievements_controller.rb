# frozen_string_literal: true

class AchievementsController < ApplicationController
  before_action :load_game, :filter_access_before_game_open, :load_message_count
  include ActionView::Helpers::TextHelper

  def index
    @achievements = Achievement.all.order(:updated_at).reverse_order
  end
end
