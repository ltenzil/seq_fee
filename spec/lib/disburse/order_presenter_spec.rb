require 'rails_helper'

require './lib/disburse/order_presenter'

RSpec.describe Disburse::OrderPresenter do

  it "should load with require" do
    expect(Disburse::OrderPresenter).to be_truthy
  end

  it "should take input from Order only" do
    order = Disburse::OrderPresenter.new(2)
    expect(order.order_id).to be_nil
  end

  it "should take input from Order only" do
    merchant   = create(:merchant)
    shopper    = create(:shopper)
    order      = create(:order, :complete, merchant: merchant, shopper: shopper)
    fee        = Disburse::Fee.range(order.amount)
    order_fee  = Disburse::Fee.order_fee(order.amount)
    amount_after_fee = Disburse::Fee.amount_after_fee(order.amount, order_fee)

    order_presenter = Disburse::OrderPresenter.new(order)
    expect(order_presenter.order_id).to eq(order.id)
    expect(order_presenter.fee).to eq(fee)
    expect(order_presenter.total_fee).to eq(order_fee)
    expect(order_presenter.pay_merchant).to eq(amount_after_fee)

  end
end
