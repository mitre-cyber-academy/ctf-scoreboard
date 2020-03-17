# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  before_action { @game = Game.instance }

  default from: ->(*) { @game.contact_email }
end
