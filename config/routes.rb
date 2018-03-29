Rails.application.routes.draw do
  devise_for :users
  root to: "question#index"
  resources :questions do
    resources :answers, only: [:create, :destroy], shallow: true
  end
end
