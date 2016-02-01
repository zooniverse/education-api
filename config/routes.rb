Rails.application.routes.draw do
  namespace :teachers do
    resources :classrooms
  end

  namespace :students do
    resources :classrooms
  end
end
