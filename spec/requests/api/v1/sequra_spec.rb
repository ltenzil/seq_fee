require 'rails_helper'

RSpec.describe "Api::V1::Sequras", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/sequra/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /disburse_report" do
    it "returns http success" do
      get "/api/v1/sequra/disburse_report"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /merchants" do
    it "returns http success" do
      get "/api/v1/sequra/merchants"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /shoppers" do
    it "returns http success" do
      get "/api/v1/sequra/shoppers"
      expect(response).to have_http_status(:success)
    end
  end

end
