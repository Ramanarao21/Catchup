Rails.application.routes.draw do
  devise_for :users

  # Root path
  root "dashboard#index"

  # Static pages
  get "dashboard/index"
  get "home/index"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Posts routes
  resources :posts, only: [:new, :create, :index] 

  # Friendships routes
  resources :friendships, only: [:index, :new, :create, :destroy] do
    member do
      patch :accept  # Accept friend request
      delete :reject # Reject friend request (optional)
    end
  end

  # **Add this line to enable user profiles**
  resources :users, only: [:show]
end
