Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get :info, to: 'informations#index'


  resources :lobbies, param: :url do
    resources :buffs
    resources :units do
      put :challenge,    on: :member, controller: 'units'
      put :heal,         on: :member, controller: 'units'
      put :resurrection, on: :member, controller: 'units'
    end
    get :action, controller: 'units'
    put :defence, controller: 'units'
    put :attack, controller: 'units'

    get    :game_over, on: :member
    post   :join,      on: :member
    put    :ready,     on: :member
    put    :start,     on: :member
    delete :leave,     on: :member
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "lobbies#index"
end
