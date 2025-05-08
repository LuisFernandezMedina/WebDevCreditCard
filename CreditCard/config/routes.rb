Rails.application.routes.draw do
  resources :users, only: [] do
    resources :payment_cards, only: [:index, :create]
  end

  resources :payment_cards, only: [:show, :update, :destroy]

  post '/payment_cards/transfer', to: 'payment_cards#transfer'

  get 'up', to: 'rails/health#show', as: :rails_health_check
end

