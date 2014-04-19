class ApplicationController < ActionController::Base
 # Prevent CSRF attacks by raising an exception.
 # For APIs, you may want to use :null_session instead.
 protect_from_forgery with: :exception
 before_filter :configure_permitted_parameters, if: :devise_controller?


 APP_DOMAIN = 'www.marlaknows.com'
  #before_filter :ensure_domain

  #def ensure_domain
   # unless request.env['HTTP_HOST'] == APP_DOMAIN || Rails.env.development?
    #  redirect_to "http://#{APP_DOMAIN}", :status => 301
    #end
  #end

  def require_admin
    unless current_user && current_user.role == 'ADMIN'
      flash[:error] = "You are not an admin"
      redirect_to root_path
    end        
  end



protected

 def configure_permitted_parameters
   devise_parameter_sanitizer.for(:sign_up) << :name
   devise_parameter_sanitizer.for(:account_update) << :name
 end
end