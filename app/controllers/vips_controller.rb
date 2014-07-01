class VipsController < ApplicationController
  def new
  	@vip = Vip.new
  end
  def create
  	@vip = Vip.new(params[:vip])
  	if @vip.save
      VipMailer.confirmation_email(@vip)
      redirect_to :root, :notice => 'You have successfully registered for a VIP account.' 
    else
      render :action => "new"
    end
  end
  def confirm
    @vip = Vip.find_by_confirmation_token(params[:confirmation_token])
    unless @vip.nil?
      @vip.confirmed = true
      @vip.confirmation_token = ""
      @vip.save
      VipMailer.welcome_email(@vip)
      redirect_to :root, :notice => "Thank you for verifying your email."
    else
      redirect_to :root, :alert => "No such confirmation token was found."
    end
  end
end
