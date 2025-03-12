class PaymentCardsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

    def index
        payment_cards = PaymentCard.all
        render json: payment_cards
    end

    def show
        payment_card = PaymentCard.find_by(id: params[:id])
        if payment_card
            render json: payment_card
        else
            render json: { error: "PaymentCard not found" }, status: :not_found
        end
    end

    def create
        Rails.logger.debug "Params recibidos: #{params.inspect}"
        payment_card = PaymentCard.new(payment_card_params)

        if payment_card.save
            render json: payment_card, status: :created
        else
            render json: { errors: payment_card.errors.full_messages }, status: :unprocessable_entity
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

    private

    def payment_card_params
        params.require(:payment_card).permit(:card_number, :cardholder_name, :cvv, :expiration_date)
    end
end
