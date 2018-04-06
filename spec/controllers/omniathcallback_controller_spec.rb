require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'twitter' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:twitter, nil)
    end

    context 'new user' do
      before { get :twitter }

      it 'render confirm_email' do
        expect(response).to render_template 'common/confirm_mail'
      end

      it 'doesnt create user' do
        expect(controller.current_user).to eq nil
      end
    end

    context 'exist user authenticate' do
      before do
        auth = mock_auth_hash(:twitter)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :twitter
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'doesnt create user' do
        expect(controller.current_user).to eq user
      end
    end
  end

  describe 'github' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:github)
    end

    context 'new user' do
      before { get :github }

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'create new user' do
        expect(controller.current_user).to_not eq nil
      end
    end

    context 'exist user authenticate' do
      before do
        auth = mock_auth_hash(:github)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :github
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'doesnt create user' do
        expect(controller.current_user).to eq user
      end
    end
  end
end