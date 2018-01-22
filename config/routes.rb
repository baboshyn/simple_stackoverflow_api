Rails.application.routes.draw do
  resources :questions, only: [:show, :index, :create, :update, :destroy]

  resources :answers, only: [:index, :update, :create, :destroy]

  resources :users, only: :create do
    collection do
      get :confirm
    end
  end

  resources :tokens, only: :create

  resource :profile, only: :show
end
