# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  before_action :load_game
end
