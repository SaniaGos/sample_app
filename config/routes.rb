Rails.application.routes.draw do
  # get "password_resets/new"
  # get "password_resets/edit"

  root "static_pages#home"       # root_path
  get "help" =>       "static_pages#help"       # help_path
  get "about" =>      "static_pages#about"
  get "contact" =>    "static_pages#contact"
  get "signup" =>     "users#new"
  get "login" =>      "sessions#new"
  post "login" =>     "sessions#create"
  delete "logout" =>  "sessions#destroy"

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users do
    collection do
      get :tigers
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
