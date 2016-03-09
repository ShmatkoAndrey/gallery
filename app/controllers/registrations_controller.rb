class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :username, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :username, :avatar)
  end
end