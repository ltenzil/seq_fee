require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Associations' do
    it "should belongs to merchant" do
      model = Order.reflect_on_association(:merchant)
      expect(model.macro).to eq(:belongs_to)
    end

    it "should belongs to shopper" do
      model = Order.reflect_on_association(:shopper)
      expect(model.macro).to eq(:belongs_to)
    end

    it "should get merchant and shopper" do
      merchant = create(:merchant)
      shopper = create(:shopper)
      order = create(:order, merchant: merchant, shopper: shopper)
      expect(order.merchant).to eq(merchant)
      expect(order.shopper).to eq(shopper)
    end
  end

  describe 'Factory validations' do
    let(:merchant) { create(:merchant) }
    let(:shopper) { create(:shopper) }

    it "should create completed order" do
      order = create(:order, :complete, merchant: merchant, shopper: shopper)
      expect(order.completed_at).not_to be_nil
      expect(Order.completed).to eq([order])
    end

    it "should create incomplete order" do
      order = create(:order, :incomplete, merchant: merchant, shopper: shopper)
      expect(order.completed_at).to be_nil      
      expect(Order.completed).to eq([])
    end

    it "should throw error on invalid amount" do
      order = create(:order, :complete, merchant: merchant, shopper: shopper)
      order.amount = nil
      expect(order).to be_invalid
    end
  end
end
