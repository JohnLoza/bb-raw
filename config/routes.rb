Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#index'
  get    '/login',   to: 'sessions#new', as: :log_in
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy', as: :log_out

  resources :users
end
