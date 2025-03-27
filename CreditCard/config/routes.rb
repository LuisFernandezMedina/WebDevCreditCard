Rails.application.routes.draw do
  
  resources :payment_cards, only: [:index, :show, :create, :update, :destroy]

  post '/payment_cards/transfer', to: 'payment_cards#transfer'

  get "up" => "rails/health#show", as: :rails_health_check

end
