class VipMailer < ActionMailer::Base
  default from: "do-not-reply@mitrecyberacademy.org"

  def confirmation_email(vip)
    @vip = vip
    mail(to: vip.email, subject: 'Please verify your VIP request for our upcoming CTF').deliver
  end
  def welcome_email(vip)
  	@vip = vip
     mail(to: vip.email, subject: 'Thank you for verifying your email!').deliver
  end
end
