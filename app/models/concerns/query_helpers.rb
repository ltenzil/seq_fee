module QueryHelpers
  extend ActiveSupport::Concern

  PAGE_LIMIT = 100

  def merchant_query(opts = {})
    return nil if !opts.is_a?(Hash) || opts[:merchant_id].blank?
    { merchant_id: opts[:merchant_id] }
  end

  def shopper_query(opts = {})
    return nil if !opts.is_a?(Hash) || opts[:shopper_id].blank?
    { shopper_id: opts[:shopper_id] }
  end

  def completed_query(opts = {})
    return nil if !opts.is_a?(Hash) || opts[:completed].blank?
    'completed_at IS NOT NULL'
  end

  def within_query(date_range)
    return nil unless date_range.is_a? Range
    { completed_at: date_range }
  end

  def completed_between(opts = {})
    return nil if opts[:start_date].blank?
    start_date = Date.parse(opts[:start_date].to_s)
    end_date   = opts[:end_date].blank? ? start_date.end_of_week : Date.parse(opts[:end_date].to_s)
    within_query(start_date..end_date)
  end

  def page(opts = {})
    return 0 if !opts.is_a?(Hash) || opts[:page].blank?
    PAGE_LIMIT * opts[:page].to_i
  end

  def date_range(date = nil)
    date = date.blank? ? Date.current.last_week : Date.parse(date.to_s)
    date.beginning_of_week..date.end_of_week
  end

end
