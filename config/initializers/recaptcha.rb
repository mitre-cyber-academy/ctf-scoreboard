Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_SITE_KEY'] ||  '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI'
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY'] || '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe'
end
