Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  post 'downloads', to: 'downloads#create'
  post 'kinesis', to: 'kinesis#create'

  resources :users

  resources :assignments

  resources :programs

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
