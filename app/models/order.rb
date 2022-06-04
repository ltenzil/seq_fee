class Order < ApplicationRecord
  validates_presence_of :amount

  belongs_to :merchant
  belongs_to :shopper

  scope :completed, -> { where.not(completed_at: nil) }

  PAGE_LIMIT = 10

  def self.search(opts = {})
    where(merchant_query(opts))
      .where(shopper_query(opts))
      .where(completed_query(opts))
      .limit(PAGE_LIMIT)
      .offset(page(opts))
      .order(created_at: :desc)
  end

  def self.merchant_query(opts)
    return nil if !opts.is_a?(Hash) || opts[:merchant_id].blank?
    { merchant_id: opts[:merchant_id] }
  end

  def self.shopper_query(opts)
    return nil if !opts.is_a?(Hash) || opts[:shopper_id].blank?
    { shopper_id: opts[:shopper_id] }
  end

  def self.completed_query(opts)
    return nil if !opts.is_a?(Hash) || opts[:completed].blank?
    'completed_at IS NOT NULL'
  end

  def self.page(opts)
    return 0 if !opts.is_a?(Hash) || opts[:page].blank?
    PAGE_LIMIT * opts[:page].to_i
  end

  def self.to_disburse(opts, week_range)
    completed
      .where(merchant_query(opts))
      .where(completed_at: week_range)
  end

end
