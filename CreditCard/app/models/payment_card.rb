class PaymentCard < ApplicationRecord
    validates :card_number, presence: true, length: { is: 16 }
    validates :cardholder_name, presence: true
    validates :cvv, presence: true, length: { is: 3 }
    validates :expiration_date, presence: true
end