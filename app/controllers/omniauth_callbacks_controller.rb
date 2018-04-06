class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_from_omniauth
  end

  def facebook
    # sign_from_omniauth
  end

  def twitter
    sign_from_omniauth
  end

  private
  def sign_from_omniauth
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:notice] = 'Email is required to compete sign up'
      render 'common/confirm_mail', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end

end