class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    format.json { render json: [exception.message], status: :forbidden}
    format.html { redirect_to root_url, alert: exception.message, status: :forbidden}
    format.js   { head :forbidden }
  end

end
