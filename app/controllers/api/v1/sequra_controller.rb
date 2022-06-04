require './lib/disburse/report'

class Api::V1::SequraController < ApplicationController

  def orders
    orders = Order.search(order_params(params).to_h)
    render json: orders
  end

  def disburse_report
    report = Disburse::Report.generate(report_params(params).to_h)
    render json: report
  end

  # def merchants
  # end

  # def shoppers
  # end

  private

  def order_params(params)
    params.permit(:completed, :page, :merchant_id, :shopper_id)
  end

  def user_params(params)
    params.permit(:name, :page, :email, :completed, :order_id)
  end

  def report_params(params)
    params.permit(:date, :merchant_id)
  end

end
