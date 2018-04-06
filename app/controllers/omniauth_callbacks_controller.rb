class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    end
  end

  def facebook
    #render json: request.env['omniauth.auth']
  end

  def twitter
    sign_from_omniauth
  end

  private

  def sign_from_omniauth
    @user = User.find_for_oauth(auth)
  end

end