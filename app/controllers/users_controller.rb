class UsersController < ApplicationController

  #will remove user affiliations with current team
  #only can be part of 1 team at a time
  def update
    user = User.where(:id => params[:id])
    user.update(params[])
    user.save
  end

  #remove a user from a team
  #deletes the user entirely
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "User was successfully removed."
    else
      flash[:error] = "There was a problem with removing the user."
    end
  redirect_to teams_path
  end
end
