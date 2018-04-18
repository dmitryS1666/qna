require "sidekiq/web"
Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks'}
  devise_scope :user do
    post '/users/auth/sign_up' => 'omniauth_callbacks#sign_up'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :rates do
    member do
      post :vote_up
      post :vote_down
      post :vote_reset
    end
  end

  concern :commented do
    member do
      post :comment
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index create show], shallow: true do
        resources :answers, only: %i[index create show]
      end
    end
  end

  resources :questions, shallow: true, concerns: %i[rates commented] do
    member do
      post :subscribe
      delete :unsubscribe
    end
    resources :answers, only: %i[create destroy update], concerns: %i[rates commented] do
      post :best_answer, on: :member
    end
  end

  get '/search' => 'search#search'

  mount ActionCable.server => '/cable'

  root to: "questions#index"
end