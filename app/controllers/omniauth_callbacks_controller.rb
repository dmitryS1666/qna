class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_from_omni, only: %i[github twitter sign_up]

  def github;  end

  def twitter; end

  def sign_up; end

  private
  def sign_from_omniauth
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Succes login!"
    else
      flash[:notice] = 'Email is required to compete sign up'
      render 'common/confirm_mail', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end

end