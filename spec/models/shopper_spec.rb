require 'rails_helper'

RSpec.describe Shopper, type: :model do
  describe 'Associations' do
    it "should have many orders" do
      model = Shopper.reflect_on_association(:orders)
      expect(model.macro).to eq(:has_many)
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
      expect(build(:shopper)).to be_valid
    end

    it "should be invalid when no name" do
      shopper = Shopper.new(name: "hello", email: nil)
      expect(shopper).not_to be_valid
    end

    it "should create record with factory" do
      shopper = create(:shopper)
      expect(shopper.name).to be_truthy
    end
  end
end
