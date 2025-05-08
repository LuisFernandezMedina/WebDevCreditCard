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
    direction        = params[:direction] # "in" o "out"
  
    if [card_number, cardholder_name, cvv, expiration_date, amount, direction].any?(&:blank?)
      return render json: { success: false, error: "Faltan parámetros" }, status: :bad_request
    end
  
    card = PaymentCard.find_by(card_number: card_number)
  
    if card
      unless card.cvv == cvv && card.expiration_date.to_s == expiration_date
        return render json: { success: false, error: "Datos incorrectos" }, status: :unauthorized
      end
    else
      # SOLO se crea si no existe
      card = PaymentCard.new(
        card_number: card_number,
        cardholder_name: cardholder_name,
        cvv: cvv,
        expiration_date: expiration_date,
        balance: 0.0
      )
  
      unless card.save
        return render json: { success: false, error: card.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    begin
      if direction == "out"
        card.charge(amount)
      elsif direction == "in"
        card.balance += amount
        card.save!(validate: false)

      else
        return render json: { success: false, error: "Dirección inválida (usa 'in' o 'out')" }, status: :bad_request
      end
  
      render json: { success: true, new_balance: card.balance }, status: :ok
  
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
