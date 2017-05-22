Rails.application.routes.draw do

  get 'health-check' => 'health_check#index'

  resources :feed_articles
  resources :feeds
  resources :identities
  root to: 'root#index'

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

end
