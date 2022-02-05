class PagesController < ApplicationController
  before_action :load_game

  def index
    @pages = @game.pages
  end

  def show
    @page = @game.pages.find_by path: params[:id].downcase
  end
end
