require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  scope controller: :static do
    get :pricing
  end

  resources :billing, only: :create

  namespace :purchase do
    resources :checkouts
  end

  get "success", to: "purchase/checkouts#success"

  resources :subscriptions
  resources :webhooks, only: :create
  resources :billings, only: :create

  root to: 'home#index'
end