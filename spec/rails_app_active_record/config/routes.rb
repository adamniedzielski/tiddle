Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users
  resources :secrets, only: [:index], defaults: { format: 'json' }
  resources :long_secrets, only: [:index], defaults: { format: 'json' }
end
