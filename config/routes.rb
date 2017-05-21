Rails.application.routes.draw do

  root to: 'root#index'

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

end
