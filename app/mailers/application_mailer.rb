# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@mitrecyberacademy.org'
  layout 'mailer'
end
