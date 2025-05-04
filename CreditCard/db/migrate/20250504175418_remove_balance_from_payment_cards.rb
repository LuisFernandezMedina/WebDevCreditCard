class RemoveBalanceFromPaymentCards < ActiveRecord::Migration[8.0]
  def change
    remove_column :payment_cards, :balance, :decimal
  end
end
