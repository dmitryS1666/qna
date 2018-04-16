class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_from_omniauth, only: %i[github twitter sign_up]

  def github;  end

  def twitter; end

  def sign_up
    session[:auth] = nil
  end

  private
  def sign_from_omniauth
    redirect_to questions_path if auth.empty?
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
    sign_in_and_redirect @user, event: :authentication
    flash[:notice] = "Succes login! #{@user.email}"
    else
      flash[:notice] = 'Email is required to compete sign up'
      session[:auth] = { uid: auth.uid, provider: auth.provider }
      render 'common/confirm_mail', locals: { auth: auth}
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params_auth)
  end

  def params_auth
    session[:auth] ? params[:auth].merge(session[:auth]) : params[:auth]
  end


end