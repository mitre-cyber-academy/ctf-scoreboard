class UsersController < ApplicationController
  def create
    @team = Team.find(params[:team_id])
    @user = @team.users.build(user_params)
    if @user.save
      redirect_to team_path(@team), :notice => 'User was successfully created.' 
    else
      redirect_to team_path(@team), :alert => @user.errors.full_messages.join(', ')
    end  
  end

  private

  def user_params # Be sure to update this in the confirmations controller as well if you need to add parameters.
    params.require(:user).permit(:username, :password, :password_confirmation, :remember_me, :team_id, :team_captain, :email, :name, :school, :year_in_school, :gender, :age, :area_of_study, :location, :personal_email, :resume)
  end
end