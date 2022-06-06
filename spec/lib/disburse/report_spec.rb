require 'rails_helper'

require './lib/disburse/report'

RSpec.describe Disburse::Report do

  it "should load with require" do
    expect(Disburse::Report).to be_truthy
  end

  it "should create object with empty orders" do
    orders = []
    report = Disburse::Report.new(orders: orders)
    expect(report).to be_truthy
    expect(report.orders).to be_empty
    expect(report.count).to eq(0)
  end

  describe "Generate Report" do
    let!(:merchant) { create(:merchant) }
    let!(:shopper) { create(:shopper) }
    let!(:merchant1) { create(:merchant, name: 'merchant Joe') }
    let!(:shopper1) { create(:shopper, name: 'Shopper Joe') }
    let!(:order1) { create(:order, :complete, merchant: merchant, shopper: shopper) }
    let!(:order2) { create(:order, :complete, merchant: merchant1, shopper: shopper1, amount: 17.5) }
    let!(:order3) { create(:order, :incomplete, merchant: merchant1, shopper: shopper1, amount: 10.5) }
    let!(:date_to_s) { Date.current.to_s }

    it "should return Report object" do
      report = Disburse::Report.generate({ date: date_to_s })
      expect(report).to be_an_instance_of(Disburse::Report)
    end

    it "should have OrderPresenter object" do
      report = Disburse::Report.generate({ date: date_to_s })
      expect(report.orders.first).to be_an_instance_of(Disburse::OrderPresenter)
    end

    it "should collect completed orders for report" do
      report = Disburse::Report.generate({ date: date_to_s })
      completed_orders = Order.completed.pluck(:completed_at)
      expect(report.orders.map(&:completed_at)).to eq(completed_orders)
      expect(report.count).to eq(report.orders.count)
    end

    it "should collect orders for merchant report" do
      report = Disburse::Report.generate({ date: date_to_s, merchant_id: merchant1.id })
      expect(report.orders.map(&:merchant_id)).to eq([merchant1.id])
    end

    it "should return date range" do
      date_range = Order.date_range(date_to_s)
      expect(date_range).to be_a_kind_of(Range)
    end

    it "should return last week range with no date" do
      date_range = Order.date_range()
      expect(date_range.first).to eq(Date.current.last_week.beginning_of_week)
    end

    it "should fetch order for date range" do
      date_range = Order.date_range(date_to_s)
      orders = Disburse::Report.fetch_orders({}, date_range)
      expect(orders.count).to eq(2)
      expect(orders.first).to be_an_instance_of(Disburse::OrderPresenter)
    end
  end

end
