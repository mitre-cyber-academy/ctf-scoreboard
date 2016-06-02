class RegistrationsController < Devise::RegistrationsController
  # DELETE /resource
  def destroy
    if update_resource(resource, account_update_params)
      resource.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message! :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    else
      flash.now[:alert] = "Current password required to delete account."
      render "edit"
    end
  end
end