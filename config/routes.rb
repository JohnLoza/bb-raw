Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#index'
  get    '/login',   to: 'sessions#new', as: :log_in
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy', as: :log_out

  resources :users
  # resources :categories
  resources :providers do
    resources :products
  end
  get 'products/', to: 'products#all_products', as: :all_products

  resources :entry_product_reports, except: [:edit, :update] do
    put 'authorize!', action: :authorize!, as: :authorize, on: :member
    # with on: :member url like model/:id/rest
    # with on: :collection url like model/rest
  end

  resources :stocks, only: :index
  resources :development_orders, except: [:edit, :update]
end
