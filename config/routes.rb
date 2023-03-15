Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :itineraries, only: [:index, :show, :create, :update, :destroy] do
    resources :events, only: [:create, :update, :destroy]
    member do
      post "edit_order"
    end
  end
  resources :places, only: [:create]
  resources :test_events, only: [:index, :update]
  get 'confirm', to: 'itineraries#confirm', as: :confirm
  get 'my_view', to: 'itineraries#my_view', as: :my_view

end
