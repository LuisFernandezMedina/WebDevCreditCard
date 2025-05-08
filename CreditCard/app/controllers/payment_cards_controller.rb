require 'stripe'
require 'ostruct'

class PaymentCardsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy, :transfer]

  # GET /users/:user_id/payment_cards
  def index
    user = User.find_by(id: params[:user_id])
    return render(json: { error: "User not found" }, status: :not_found) unless user

    render json: user.payment_cards
  end 

  def show
    payment_card = PaymentCard.find_by(id: params[:id])
    if payment_card
      render json: payment_card
    else
      render json: { error: "PaymentCard not found" }, status: :not_found
    end
  end

  # POST /users/:user_id/payment_cards
  def create
    user = User.find_by(id: params[:user_id])
    return render(json: { error: "User not found" }, status: :not_found) unless user

    card = user.payment_cards.new(payment_card_params)
    if card.save
      render json: card, status: :created
    else
      render json: { errors: card.errors.full_messages }, status: :unprocessable_entity
    end
  end 

  def update
    payment_card = PaymentCard.find_by(id: params[:id])
    if payment_card&.update(payment_card_params)
      render json: payment_card
    else
      render json: { error: "Unable to update payment card" }, status: :unprocessable_entity
    end
  end

  def destroy
    payment_card = PaymentCard.find_by(id: params[:id])
    if payment_card&.destroy
      render json: { message: "PaymentCard deleted successfully" }
    else
      render json: { error: "PaymentCard not found" }, status: :not_found
    end
  end

  # POST /payment_cards/transfer
  def transfer
    Rails.logger.debug "Transfer params: #{params.inspect}"
  
    card_number      = params[:card_number]
    cardholder_name  = params[:cardholder_name]
    cvv              = params[:cvv]
    expiration_date  = params[:expiration_date]
    amount           = params[:amount].to_f
    direction        = params[:direction]
  
    if [card_number, cardholder_name, cvv, expiration_date, amount].any?(&:blank?)
      return render json: { success: false, error: "Faltan parámetros" }, status: :bad_request
    end
  
    if direction != "in"
      return render json: { success: false, error: "Solo se permiten cargas con direction: 'in'" }, status: :bad_request
    end
  
    begin
      # Crear token con datos de la tarjeta (para pruebas)
      token_id = "tok_visa"  # 🔹 token chorra de Stripe

    charge = Stripe::Charge.create({
      amount: (amount * 100).to_i,
      currency: 'usd',
      source: token_id,
      description: "Crédito para #{cardholder_name}"
    })
  
      card = PaymentCard.find_or_initialize_by(card_number: card_number)
      card.cardholder_name = cardholder_name
      card.cvv = cvv
      card.expiration_date = expiration_date
      render json: { success: true, charge_id: charge.id }, status: :ok
  
    rescue Stripe::CardError => e
      render json: { success: false, error: e.message }, status: :payment_required
    rescue => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end
  end
  
  
  private

  def payment_card_params
    params.require(:payment_card)
          .permit(:card_number, :cardholder_name, :cvv, :expiration_date)
  end
end
