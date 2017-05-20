# frozen_string_literal: true

# Controller for the homepage. Since there is not much logic on the homepage this controller is
# rather empty.
class HomeController < ApplicationController
  before_action :load_game, :load_message_count

  def index; end
end
