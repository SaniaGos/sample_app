Rails.application.routes.draw do
  root "static_pages#home"                # root_path
  get "help"    => "static_pages#help"       # help_path
  get "about"   => "static_pages#about"
  get "contact" => "static_pages#contact"
  get "signup"  => "users#new"

  resources :users

  get    "login"  => "sessions#new"
  post   "login"  => "sessions#create"
  delete "logout" => "sessions#destroy"
end
