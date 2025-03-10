class PaymentCardsController < ApplicationController
    def create
        Rails.logger.debug "Params recibidos: #{params.inspect}"
      
        payment_card = PaymentCard.new(payment_card_params)

        if payment_card.save
            render json: payment_card, status: :created
        else
            render json: { errors: payment_card.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def payment_card_params
        params.require(:payment_card).permit(:card_number, :cardholder_name, :cvv, :expiration_date)
    end
end
