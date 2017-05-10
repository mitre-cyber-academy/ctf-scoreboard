# frozen_string_literal: true

# Controller for the homepage. Since there is not much logic on the homepage this controller is
# rather empty.
class HomeController < ApplicationController
  def index
    @game = Game.instance
  end
end
