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
    #will remove user affiliations with current team
    #only can be part of 1 team at a time
  def update
    user = User.where(:id => params[:id])
    user.update(params[])
    user.save
  end
#remove a user from a team
#deletes the user entirely
def destory
  @user = User.find(params[:id])
  if @user.destory
    flash[:notice] = "User was successfully removed."
  else
    flash[:error] = "There was a problem with removing the user."
  end
  redirect_to teams_path
end

    #will remove user affiliations with current team
    #only can be part of 1 team at a time
  def update
    user = User.where(:id => params[:id])
    user.update(params[])
    user.save
  end

  #remove a user from a team
  #deletes the user entirely
  def destory
    @user = User.find(params[:id])
    if @user.destory
    flash[:notice] = "User was successfully removed."
    else
    flash[:error] = "There was a problem with removing the user."
    end
  redirect_to teams_path
  end

  private

  def user_params # Be sure to update this in the confirmations controller as well if you need to add parameters.
    params.require(:user).permit(:username, :password, :password_confirmation, :remember_me, :team_id, :team_captain, :email, :name, :school, :year_in_school, :gender, :compete_for_prizes ,:age, :area_of_study, :location, :state,:personal_email, :resume, :verification)
  end
end
