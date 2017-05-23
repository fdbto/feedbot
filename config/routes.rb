Rails.application.routes.draw do

  resources :cron_jobs
  get 'health-check' => 'health_check#index'
  post 'tick' => 'clock#tick'

  resources :feed_articles
  resources :feeds
  resources :identities
  root to: 'root#index'
  get '/home', to: 'root#home', as: :home

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

end
