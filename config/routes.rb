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
    # with on: :member url like model/:id/action
    # with on: :collection url like model/action
  end

  resources :stocks, only: :index do
    get 'by_provider/:provider_id', action: :by_provider,
      as: :by_provider, on: :collection
    get 'tracking', action: :track, on: :collection
  end

  resources :devolutions, except: [:edit, :update] do
    put 'authorize!', action: :authorize!, as: :authorize, on: :member
  end

  resources :development_orders, except: [:edit, :update] do
    resources :supplies, only: [:index, :new, :create] do
      put 'authorize!', action: :authorize!, as: :authorize, on: :collection
      put 'return!', action: :return!, as: :return, on: :collection
    end

    get 'my_authorized_orders', action: :my_authorized_orders, as: :my_authorized,
      on: :collection
    put 'finish_formulation_processes', action: :finish_formulation_processes!,
      as: :finish_formulation_processes_for, on: :member

    resources :formulation_processes, only: [:index, :new, :create, :show]
  end
  get 'formulation_processes/tags' => 'formulation_processes#tags', as: :formulation_processes_tags

  resources :production_orders, except: [:edit, :update, :destroy]
  get 'production_orders/tags/print' => 'production_orders#tags', as: :production_orders_tags

  resources :bb_products

  resources :bb_entry_reports, except: [:edit, :update] do
    put 'authorize!', action: :authorize!, as: :authorize, on: :member
  end

  resources :bb_stocks, only: [:index]

  resources :bb_exit_reports, except: [:edit, :update] do
    put 'authorize!', action: :authorize!, as: :authorize, on: :member
  end

  resources :goods do
    get 'use', action: :use, as: :use, on: :member
    get 'retrieve', action: :retrieve, as: :retrieve, on: :member
    get 'qr_codes', action: :qr_codes, as: :qr_codes_for, on: :member
  end

end
