Rails.application.routes.draw do
  resources  :questions

  resources :answers

  resource :user, only: :create
end
