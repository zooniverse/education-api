Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :users

  namespace :teachers do
    resources :classrooms
  end

  namespace :students do
    resources :classrooms do
      member do
        post :join
      end
    end
  end
end
