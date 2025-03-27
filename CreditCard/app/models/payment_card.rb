class PaymentCard < ApplicationRecord
    validates :card_number, presence: true, length: { is: 16 }, uniqueness: true
    validates :cardholder_name, presence: true
    validates :cvv, presence: true, length: { is: 3 }
    validates :expiration_date, presence: true
    validates :balance, numericality: { greater_than_or_equal_to: 0 }

    # Método para cobrar dinero de la tarjeta
    def charge(amount)
        raise "Fondos insuficientes" if amount > balance
        update!(balance: balance - amount)
    end
    
end
