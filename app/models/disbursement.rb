class Disbursement < ApplicationRecord
  belongs_to :order
  belongs_to :merchant

  validates_uniqueness_of :order_id, presence: true
  validates :amount, :fee, :total_fee, :pay_merchant, :completed_at, presence: true

  extend QueryHelpers

  def self.add_orders(orders)
    return if orders.blank?
    orders.each do |order|
      next unless order.class.to_s == 'Disburse::OrderPresenter'
      disbursement = Disbursement.new(order.attributes)
      unless disbursement.save
        Rails.logger.info "Unable to create Disbursement for order: #{order.order_id}"
        Rails.logger.info "Errors: #{disbursement.errors.full_messages}"
      end
    end
  end

  def self.search(opts = {})
    select('*, count(*) OVER() AS hits')
      .where(merchant_query(opts))
      .where(completed_between(opts))
      .limit(QueryHelpers::PAGE_LIMIT)
      .offset(page(opts))
  end

end
