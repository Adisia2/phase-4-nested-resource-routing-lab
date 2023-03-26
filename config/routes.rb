Rails.application.routes.draw do
  resources :users, only: [:show] do
  resources :items, only: [:index, :show, :create]
  end

  get '/items', to: 'items#index'
end
