ActionMailer::Base.default_url_options[:host] = ENV['MAILER_DEFAULT_URL_OPTIONS_HOST'] || 'localhost:3000'
ActionMailer::Base.smtp_settings = {
  address: ENV['MAILER_ADDRESS'],
  port: ENV['MAILER_PORT'],
  domain: ENV['MAILER_DOMAIN'],
  authentication: ENV['MAILER_AUTHENTICATION']&.to_sym,
  tls: ActiveModel::Type::Boolean.new.cast(ENV['MAILER_TLS']),
  openssl_verify_mode: ENV['MAILER_OPENSSL_VERIFY_MODE'],
  enable_starttls_auto: ActiveModel::Type::Boolean.new.cast(ENV['MAILER_ENABLE_STARTTLS_AUTO']),
  user_name: ENV['MAILER_SMTP_SERVER_USERNAME'],
  password: ENV['MAILER_SMTP_SERVER_PASSWORD']
}
