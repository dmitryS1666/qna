Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

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