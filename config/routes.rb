Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post '/users/auth/sign_up' => 'omniauth_callbacks#sign_up'
  end

  namespace :api do
    namespace :v1 do
      resource :profiles, only: :index do
        get :me, on: :collection
      end
      resource :questions
    end
  end

  root 'questions#index'

  concern :votable do
    member do
      post :create_vote
      delete :delete_vote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], only: [:create, :destroy, :update], shallow: true do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end