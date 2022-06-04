require 'rails_helper'

require './lib/disburse/fee'

RSpec.describe Disburse::Fee do

  it "should load with require" do
    expect(Disburse::Fee).to be_truthy
  end

  it "should return fee for amount" do
    amount1 = 25
    amount2 = 85
    amount3 = 345
    fee1 = Disburse::Fee.range(amount1)
    fee2 = Disburse::Fee.range(amount2)
    fee3 = Disburse::Fee.range(amount3)
    expect(fee1).to eq(0.01)
    expect(fee2).to eq(0.0095)
    expect(fee3).to eq(0.0085)
  end

  it "should return order fee for amount" do
    order_amount1 = 25
    order_amount2 = 85
    order_amount3 = 345
    order_fee1 = Disburse::Fee.order_fee(order_amount1)
    order_fee2 = Disburse::Fee.order_fee(order_amount2)
    order_fee3 = Disburse::Fee.order_fee(order_amount3)
    expect(order_fee1).to eq((25 * 0.01).round(2))
    expect(order_fee2).to eq((85 * 0.0095).round(2))
    expect(order_fee3).to eq((345 * 0.0085).round(2))
  end

  it "should return amount after fee" do
    order_amount1 = 25
    order_amount2 = 85
    order_amount3 = 345
    order_fee1 = Disburse::Fee.order_fee(order_amount1)
    order_fee2 = Disburse::Fee.order_fee(order_amount2)
    order_fee3 = Disburse::Fee.order_fee(order_amount3)

    pay_merchant1 = Disburse::Fee.amount_after_fee(order_amount1, order_fee1)
    pay_merchant2 = Disburse::Fee.amount_after_fee(order_amount2, order_fee2)
    pay_merchant3 = Disburse::Fee.amount_after_fee(order_amount3, order_fee3)

    expect(pay_merchant1).to eq((order_amount1 - order_fee1).round(2))
    expect(pay_merchant2).to eq((order_amount2 - order_fee2).round(2))
    expect(pay_merchant3).to eq((order_amount3 - order_fee3).round(2))
  end

end
