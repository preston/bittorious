class RegistrationsController < Devise::RegistrationsController

  def destroy
    if resource.destroy
      set_flash_message :notice, :destroyed
      sign_out_and_redirect(self.resource)
    else
      flash[:error] = "You must transfer ownership of your files before you delete your account."
      redirect_to edit_user_registration_path
    end
  end

  private
 
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
 
  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end