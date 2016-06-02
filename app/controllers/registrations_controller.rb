class RegistrationsController < Devise::RegistrationsController
  # DELETE /resource
  def destroy
    if resource.team_captain?
      set_flash_message! :alert, :captain_tried_to_destroy
      render "edit"
    elsif update_resource(resource, account_update_params)
      if resource.on_a_team?
        resource.leave_team
      end
      resource.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message! :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    else
      render "edit"
    end
  end
end