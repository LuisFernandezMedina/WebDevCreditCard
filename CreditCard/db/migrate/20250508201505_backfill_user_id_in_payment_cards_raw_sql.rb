class BackfillUserIdInPaymentCardsRawSql < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE payment_cards
      SET user_id = (SELECT id FROM users ORDER BY id LIMIT 1)
      WHERE user_id IS NULL;
    SQL
  end

  def down
    # no-op
  end
end

