Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users
  devise_for :namespaced_user, class_name: 'Namespace::NamespacedUser'
  resources :secrets, only: [:index], defaults: { format: 'json' }
  resources :long_secrets, only: [:index], defaults: { format: 'json' }
  resources :namespaced_users, only: [:index], defaults: { format: 'json' }
end
