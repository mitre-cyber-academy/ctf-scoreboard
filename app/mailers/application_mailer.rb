# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  before_action { @game = Game.instance }

  default from: -> { @game.do_not_reply_email }
end
