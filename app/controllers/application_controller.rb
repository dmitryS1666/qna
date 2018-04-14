class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    format.json { render json: [exception.message], status: :forbidden}
    format.html { redirect_to root_url, alert: exception.message, status: :forbidden}
    format.js   { head :forbidden }
  end

end
