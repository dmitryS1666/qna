class ApplicationController < ActionController::Base
  include Serialized

  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :gon_user, unless: :devise_controller?

  load_and_authorize_resource

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    format.json { render json: [exception.message], status: :forbidden}
    format.html { redirect_to root_url, alert: exception.message, status: :forbidden}
    format.js   { head :forbidden }
  end

end
