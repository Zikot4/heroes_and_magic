Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :lobbies, param: :url do
    resources :units do
      put :challenge, on: :member, controller: 'units'
      put :heal, on: :member, controller: 'units'
    end
    get :action, controller: 'units'
    put :defence, controller: 'units'
    put :attack, controller: 'units'

    post :join, on: :member
    put :ready, on: :member
    put :start, on: :member
    delete :leave, on: :member
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "lobbies#index"
end
