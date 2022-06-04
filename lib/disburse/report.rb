require './lib/disburse/order_presenter'

module Disburse

  class ReportError < StandardError; end

  class Report

    attr_reader :orders, :count, :title, :status, :week_range

    def initialize(orders: [], week_range: [], status: 'Not Found')
      @title  = 'Weekly Disburse Report'
      @count  = orders.try(:count)
      @orders = orders
      @status = status
      @week_range = week_range
    end

    def self.generate(opts = {})
      begin
        range  = date_range(opts[:date])
        orders = fetch_orders(opts, range)
        status = 'Success'
      rescue ReportError => e
        orders = []
        status = "Failed: #{e.message}, Please after sometime"
      end
      Report.new(orders: orders, week_range: range, status: status)
    end

    def self.date_range(date = nil)
      date = date.blank? ? Date.today.last_week : Date.parse(date)
      date.beginning_of_week..date.end_of_week
    end

    def self.fetch_orders(opts, week_range)
      orders = Order.to_disburse(opts, week_range)
      orders.map { |order| Disburse::OrderPresenter.new(order) }
    end

  end

end
