Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :itineraries, only: [:index, :show, :create, :update, :destroy] do
    resources :events, only: [:create, :update, :destroy] do
      # member do
      #   get "remove"
      # end
    end

    member do
      post "edit_order"
    end

  end
  resources :places, only: [:create]
  resources :test_events, only: [:index, :update]

  get "remove/:id", to: "events#remove", as: :remove
end
