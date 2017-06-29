# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController
  before_action :load_game, :load_message_count
end
