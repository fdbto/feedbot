Rails.application.routes.draw do

  resources :identities
  root to: 'root#index'

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

end
