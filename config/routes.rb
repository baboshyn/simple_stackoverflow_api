Rails.application.routes.draw do
  resources :questions, only: [:create, :update, :show, :index, :destroy]

  resources :answers, only: [:create, :update, :index, :destroy]

  resources :users, only: :create

  resources :tokens, only: :create

  resource :profile, only: :show

  resource :confirmation, only: :show
end
