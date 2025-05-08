class PaymentCard < ApplicationRecord
    attr_readonly :card_number

    validates :card_number, presence: true, length: { is: 16 }, uniqueness: { case_sensitive: false }
    validates :cardholder_name, presence: true
    validates :cvv, presence: true, length: { is: 3 }
    validates :expiration_date, presence: true
        
end
