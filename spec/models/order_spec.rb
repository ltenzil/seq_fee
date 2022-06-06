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
    let!(:order4) { create(:order, :complete, merchant: merchant1, shopper: shopper1,
                           amount: 17.5, completed_at: Date.current.end_of_month) }

    it "should include fields in search via options" do
      sql = Order.search({merchant_id: merchant.id}).to_sql
      expect(sql).not_to include('shopper_id')
      expect(sql).to include('merchant_id')
      expect(sql).to include('LIMIT')
      expect(sql).to include("orders\".\"created_at\" DESC")
    end

    it "should search and list all orders" do
      orders = Order.search()
      expect(orders).to eq([order4, order3, order2, order1]) # ordered by desc
    end

    it "should search and list completed orders" do
      orders = Order.search({completed: true})
      expect(orders).to eq([order4, order2, order1])
    end

    it "should search by merchant and list orders" do
      orders = Order.search({merchant_id: merchant.id})
      expect(orders).to eq([order1])
    end

    it "should search by shopper and list orders" do
      orders = Order.search({shopper_id: shopper1.id})
      expect(orders).to eq([order4, order3, order2])
    end

    it "should return completed orders to disbursed for the week" do
      date = Date.current
      week_range = date.beginning_of_week..date.end_of_week
      orders = Order.to_disburse({date: date.to_s}, week_range)
      expect(orders.map(&:completed_at)).to eq([order1.completed_at, order2.completed_at])
      expect(week_range).to include(orders.first.completed_at.to_date)
      expect(orders).not_to include(order4)
    end

    it "should return orders to disbursed for the week - given start date " do
      start_date = Date.current.to_s
      orders = Order.search({start_date: start_date})
      expect(orders.map(&:completed_at)).to eq([order2.completed_at, order1.completed_at])
    end

    it "should return orders to disbursed for given start & end date " do
      start_date = Date.current.to_s
      end_date = Date.current.end_of_month.to_s
      orders = Order.search({start_date: start_date, end_date: end_date})
      expect(orders.map(&:completed_at)).to eq([order4.completed_at, order2.completed_at, order1.completed_at])
    end
  end

  describe "Query helpers" do
    it_behaves_like 'queryable'
  end
end
