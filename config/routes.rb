Rails.application.routes.draw do
  resources :questions, only: [:create, :show, :index, :update, :destroy]

  resources :answers, only: [:create, :index, :update, :destroy]

  resources :users, only: :create do
    collection do
      get :confirm
    end
  end

  resources :tokens, only: :create

  resource :profile, only: :show
end
