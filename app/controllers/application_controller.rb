class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :no_authoriz_user, only: [:edit]
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { locale: I18n.locale }.merge options
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  def no_authoriz_user
    if current_user && !current_user.email_verified? # && illegal_pages.include?(action_name)  action_name != 'finish_signup'
      redirect_to finish_signup_path(current_user)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation,
                                                            :remember_me, :name, :avatar) }

    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }

    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation,
                                                                   :current_password, :name, :avatar) }
  end
end