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

  describe "search orders" do
    let!(:merchant) { create(:merchant) }
    let!(:shopper) { create(:shopper) }
    let!(:merchant1) { create(:merchant, name: "merchant Joe") }
    let!(:shopper1) { create(:shopper, name: "Shopper Joe") }
    let!(:order1) { create(:order, :complete, merchant: merchant, shopper: shopper) }
    let!(:order2) { create(:order, :complete, merchant: merchant1, shopper: shopper1, amount: 17.5) }
    let!(:order3) { create(:order, :incomplete, merchant: merchant1, shopper: shopper1, amount: 10.5) }

    it "should include fields in search via options" do
      sql = Order.search({merchant_id: merchant.id}).to_sql
      expect(sql).not_to include('shopper_id')
      expect(sql).to include('merchant_id')
      expect(sql).to include('LIMIT')
      expect(sql).to include("orders\".\"created_at\" DESC")
    end

    it "should search and list all orders" do
      orders = Order.search()
      expect(orders).to eq([order3, order2, order1]) # ordered by desc
    end

    it "should search and list completed orders" do
      orders = Order.search({completed: true})
      expect(orders).to eq([order2, order1])
    end

    it "should search by merchant and list orders" do
      orders = Order.search({merchant_id: merchant.id})
      expect(orders).to eq([order1])
    end

    it "should search by shopper and list orders" do
      orders = Order.search({shopper_id: shopper1.id})
      expect(orders).to eq([order3, order2])
    end

    it "should return completed orders to disbursed for the week" do
      date = Date.today
      week_range = date.beginning_of_week..date.end_of_week
      orders = Order.to_disburse({date: date.to_s}, week_range)
      expect(orders.map(&:completed_at)).to eq([order1.completed_at, order2.completed_at])
      expect(week_range).to include(orders.first.completed_at.to_date)
    end
  end
end
