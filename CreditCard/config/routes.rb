Rails.application.routes.draw do
  
  resources :payment_cards, only: [:index, :show, :create, :update, :destroy]

  post '/validate_card', to: 'payment_cards#validate_card'

  get "up" => "rails/health#show", as: :rails_health_check

end
