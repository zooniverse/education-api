Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :users

  resources :assignments

  namespace :teachers do
    resources :classrooms do
      resources :student_users
    end
  end

  namespace :students do
    resources :classrooms do
      member do
        post :join
      end
    end
  end
end
