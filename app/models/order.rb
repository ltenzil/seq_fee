class Order < ApplicationRecord
  validates_presence_of :amount

  belongs_to :merchant
  belongs_to :shopper

  extend QueryHelpers

  scope :completed, -> { where.not(completed_at: nil) }

  def self.search(opts = {})
    select('*, count(*) OVER() AS hits')
      .where(merchant_query(opts))
      .where(shopper_query(opts))
      .where(completed_query(opts))
      .where(completed_between(opts))
      .limit(QueryHelpers::PAGE_LIMIT)
      .offset(page(opts))
      .order(created_at: :desc)
  end

  def self.to_disburse(opts = {}, week_range = [])
    completed
      .where(merchant_query(opts))
      .where(within_query(week_range))
  end

end
