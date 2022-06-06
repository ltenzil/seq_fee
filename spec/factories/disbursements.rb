require './lib/disburse/fee'

FactoryBot.define do
  factory :disbursement do
    association :merchant
    association :order
    amount { order.amount }
    fee { Disburse::Fee.range(order.amount) }
    total_fee { Disburse::Fee.order_fee(order.amount) }
    pay_merchant { Disburse::Fee.amount_after_fee(order.amount, total_fee) }
    is_paid { false }
    completed_at { order.completed_at }
  end
end
