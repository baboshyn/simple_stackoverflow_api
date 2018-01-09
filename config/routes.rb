Rails.application.routes.draw do
  resources :questions, only: [:create, :update, :show, :index, :destroy]

  resources :answers, only: [:create, :update, :index, :destroy]

  resources :users, only: :create do
    collection do
      get 'confirm'
    end
  end

  resources :tokens, only: :create

  resource :profile, only: :show
end
