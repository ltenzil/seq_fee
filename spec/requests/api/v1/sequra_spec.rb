require 'rails_helper'

RSpec.describe "Api::V1::Sequras", type: :request do

  describe "GET /orders" do
    let!(:merchant) { create(:merchant) }
    let!(:shopper) { create(:shopper) }
    let!(:orderc) { create(:order, :complete, merchant: merchant, shopper: shopper) }

    it "returns http success" do
      get "/api/v1/sequra/orders"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).keys).to eq(['count', 'data', 'page'])
    end
  end

  describe "GET /disburse_report" do

    let!(:merchant) { create(:merchant) }
    let!(:shopper) { create(:shopper) }
    let!(:order) { create(:order, :complete, merchant: merchant, shopper: shopper) }
    let!(:iorder) { create(:order, :incomplete, merchant: merchant, shopper: shopper) }

    it "returns http success" do
      get "/api/v1/sequra/disburse_report"
      expect(response).to have_http_status(:success)
    end

    it "returns completed orders with merchant fee" do
      sequra_fee   = Disburse::Fee.range(order.amount)
      total_fee    = Disburse::Fee.order_fee(order.amount)
      pay_merchant = Disburse::Fee.amount_after_fee(order.amount, total_fee)

      get "/api/v1/sequra/disburse_report", params: {date: Date.current}
      resp     = JSON.parse(response.body)
      reporder = resp['orders']&.first

      expect(resp['title']).to eq('Weekly Disburse Report')
      expect(resp['count']).to eq(1)
      expect(reporder['order_id']).not_to eq(iorder.id)
      expect(reporder['completed_at']).to be_truthy
      expect(reporder['pay_merchant']).to eq(pay_merchant)
    end
  end

  describe "GET /disbursements" do
    let!(:merchant) { create(:merchant) }
    let!(:shopper) { create(:shopper) }
    let!(:order) { create(:order, :complete, merchant: merchant, shopper: shopper) }
    let!(:iorder) { create(:order, :incomplete, merchant: merchant, shopper: shopper) }
    let!(:disbursement) { create(:disbursement, order: order, merchant: merchant) }

    it "returns http success" do
      get "/api/v1/sequra/disbursements"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).keys).to eq(['count', 'data', 'page'])
    end

    it "should return disbursements" do
      get "/api/v1/sequra/disbursements"
      resp = JSON.parse(response.body)      
      expect(resp['data'][0]['order_id']).to eq(order.id)
      expect(resp['data'][0]['order_id']).not_to eq(iorder.id)
    end
  end

  # describe "GET /merchants" do
  #   it "returns http success" do
  #     get "/api/v1/sequra/merchants"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "GET /shoppers" do
  #   it "returns http success" do
  #     get "/api/v1/sequra/shoppers"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
