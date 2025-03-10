class CreatePaymentCards < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_cards do |t|
      t.string :card_number
      t.string :cardholder_name
      t.string :cvv
      t.date :expiration_date

      t.timestamps
    end
  end
end
