Rails.application.routes.draw do
  devise_for :users
  resources :secrets, only: [:index], defaults: { format: 'json' }
end
