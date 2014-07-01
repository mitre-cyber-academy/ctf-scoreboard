class UsersController < ApplicationController
  def create
    @team = Team.find(params[:team_id])
    @user = @team.users.build(params[:user])
    if @user.save
      redirect_to team_path(@team), :notice => 'User was successfully created.' 
    else
      redirect_to team_path(@team), :alert => @user.errors.full_messages.join(', ')
    end  
  end
end