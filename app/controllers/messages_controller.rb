# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :load_game

  def index
    @messages = @game.messages.order(:updated_at).reverse_order.page(params[:page]).per(10)
    current_user&.update_messages_stamp
  end
end
