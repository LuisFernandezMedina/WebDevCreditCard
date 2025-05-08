class MakeUserIdNotNullOnPaymentCards < ActiveRecord::Migration[8.0]
  def change
    change_column_null :payment_cards, :user_id, false
  end
end
