class PaymentCard < ApplicationRecord
    attr_readonly :card_number

    validates :card_number, presence: true, length: { is: 16 }, uniqueness: { case_sensitive: false }
    validates :cardholder_name, presence: true
    validates :cvv, presence: true, length: { is: 3 }
    validates :expiration_date, presence: true
    validates :balance, numericality: { greater_than_or_equal_to: 0 }

    def charge(amount)
        raise "Fondos insuficientes" if amount > balance
        self.balance = balance - amount
        save!(validate: false) # ⚠️ Omitimos validaciones que ya sabemos que no han cambiado
      end
      
    
end
