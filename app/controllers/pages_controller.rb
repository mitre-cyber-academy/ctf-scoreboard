class PagesController < ApplicationController
  before_action :load_game

  def show
    @page = @game.pages.find_by path: params[:id]
  end
end
