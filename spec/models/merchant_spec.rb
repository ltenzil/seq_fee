require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'Associations' do
    it "should have many orders" do
      merchant = Merchant.reflect_on_association(:orders)
      expect(merchant.macro).to eq(:has_many)
    end

    it "should create orders" do
      merchant = create(:merchant)
      shopper = create(:shopper)
      order = create(:order, merchant: merchant, shopper: shopper)
      expect(order.merchant).to eq(merchant)
      expect(order.shopper).to eq(shopper)
    end
  end

  describe "Factory Validations" do
    it "should have a valid factory" do
      expect(build(:merchant)).to be_valid
    end

    it "should be invalid when no name" do
      merchant = Merchant.new(name: nil, email: "hello@gmaill.com")      
      expect(merchant).not_to be_valid
    end

    it "should create record with factory" do
      merchant = create(:merchant)
      expect(merchant.name).to be_truthy
    end
  end
end
