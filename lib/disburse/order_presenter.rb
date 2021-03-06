require './lib/disburse/fee'

module Disburse

  class OrderPresenter

    attr_reader :order_id, :merchant_id, :amount, :fee,
                :total_fee, :pay_merchant, :completed_at

    def initialize(order)
      return unless order.is_a? Order
      @order_id     = order.id
      @merchant_id  = order.merchant_id
      @amount       = order.amount
      @fee          = Disburse::Fee.range(order.amount)
      @total_fee    = Disburse::Fee.order_fee(order.amount)
      @pay_merchant = Disburse::Fee.amount_after_fee(order.amount, @total_fee)
      @completed_at = order.completed_at
    end

    def attributes
      {
        order_id: order_id,
        merchant_id: merchant_id,
        amount: amount,
        fee: fee,
        total_fee: total_fee,
        pay_merchant: pay_merchant,
        completed_at: completed_at
      }
    end

  end

end
