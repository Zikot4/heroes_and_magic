Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :lobbies, param: :url do
    get :join, on: :member
    get :ready, on: :member
    get :start, on: :member
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "lobbies#index"
end
