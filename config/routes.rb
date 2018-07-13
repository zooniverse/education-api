require 'sidekiq/web'

Rails.application.routes.draw do
  root 'application#root'

  unless Rails.env.test? || Rails.env.development?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      usernames_match = ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"]
      ))
      passwords_match = ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"])
      )
      usernames_match & passwords_match
    end
  end
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
