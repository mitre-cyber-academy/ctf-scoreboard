# frozen_string_literal: true

# We load our settings first so that we can access them
# in other initializers

require_relative '../settings'

Settings['smtp'] ||= Settingslogic.new({})
Settings.smtp['enabled'] = false if Settings.smtp['enabled'].nil?

Settings['providers'] ||= Settingslogic.new({})

Settings['contact_email'] = 'do_not_reply@scoreboard' if Settings['contact_email'].blank?
