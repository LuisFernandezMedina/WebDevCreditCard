require 'rails_helper'

RSpec.describe "PaymentCards API", type: :request do
  let(:valid_attributes) { { card_number: "1234567812345678", cardholder_name: "John Doe", cvv: "123", expiration_date: "2030-12-01" } }
  let(:invalid_attributes) { { card_number: "123456781234567", cardholder_name: "", cvv: "12", expiration_date: "" } }
  let!(:payment_card) { PaymentCard.create!(valid_attributes) }

  describe "GET /payment_cards" do
    it "returns a list of payment cards" do
      get "/payment_cards"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "GET /payment_cards/:id" do
    it "returns a payment card" do
      get "/payment_cards/#{payment_card.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["card_number"]).to eq(payment_card.card_number)
    end

    it "returns not found for non-existent card" do
      get "/payment_cards/999999"
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("PaymentCard not found")
    end
  end


  describe "PUT /payment_cards/:id" do
    it "updates a payment card" do
      put "/payment_cards/#{payment_card.id}", params: { payment_card: { cardholder_name: "Jane Doe" } }
      payment_card.reload
      expect(payment_card.cardholder_name).to eq("Jane Doe")
      expect(response).to have_http_status(:ok)
    end

    it "returns an error if update is invalid" do
      put "/payment_cards/#{payment_card.id}", params: { payment_card: { cvv: "12" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /payment_cards/:id" do
    it "deletes a payment card" do
      expect {
        delete "/payment_cards/#{payment_card.id}"
      }.to change(PaymentCard, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("PaymentCard deleted successfully")
    end
  end


end
