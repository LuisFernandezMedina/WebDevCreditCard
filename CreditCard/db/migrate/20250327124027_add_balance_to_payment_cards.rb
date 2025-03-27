class AddBalanceToPaymentCards < ActiveRecord::Migration[8.0]
  def change
    add_column :payment_cards, :balance, :decimal, precision: 12, scale: 2, default: 10000.00
  end
end
