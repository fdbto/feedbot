Rails.application.routes.draw do

  authenticate :user do
    mount Que::Web, at: 'que'
  end

  get 'health-check' => 'health_check#index'
  post 'tick' => 'clock#tick'

  resources :subscriptions, only: %i(index) do
    member do
      get :webhook
      post :webhook
    end
  end

  resources :feeds do
    resources :feed_articles
  end
  resources :identities

  root to: 'root#index'
  get '/home', to: 'root#home', as: :home

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get '/admin', to: 'admin#index', as: :admin
  resources :cron_jobs
end
