Rails.application.routes.draw do
  resources :questions

  resources :answers, only: [:create, :update, :index, :destroy]

  resource :user, only: :create

  resource :token, only: :create

  resource :profile, only: :show
end
