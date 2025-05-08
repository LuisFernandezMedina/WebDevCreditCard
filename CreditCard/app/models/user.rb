class User < ApplicationRecord
    has_secure_password
  
    has_many :payment_cards, dependent: :destroy
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
  
    enum :role, { normal: 0, admin: 1 }
end
  