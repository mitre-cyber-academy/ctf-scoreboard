class EdditUserInformationController < ApplicationController
	#this is for allowing the user to edit there information
  def show
  	#@user = User.find(params[:id])
  end

  def new
  end

  def edit
  	@user = User.find(params[:id])
  end

  private
  #this is allowing them to edit there infromation, choosing what info they can edit
  	def user_params
  		params.require(:user).permit(:username, :password, :password_confirmation, :remember_me, :team_id, :team_captain, :email, :name, :school, :year_in_school, :gender, :play_for_money,:still_compete ,:age, :area_of_study, :location, :state,:personal_email, :resume, :verification)
  	end
end
