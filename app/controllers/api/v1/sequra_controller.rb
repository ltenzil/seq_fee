require './lib/disburse/report'

class Api::V1::SequraController < ApplicationController

  def orders
    data = Order.search(order_params(params).to_h)
    render json: handle_response(data, params)
  end

  def disburse_report
    data = Disburse::Report.generate(report_params(params).to_h)
    render json: data
  end

  def disbursements
    data = Disbursement.search(disbursement_params(params).to_h)
    render json: handle_response(data, params)
  end

  # Planned improvements

  # def merchants
  # end

  # def shoppers
  # end

  private

  def handle_response(data, params)
    {
      count: data&.first&.hits.to_i,
      data: data.map { |record| record.attributes.except('hits') },
      page: params[:page].to_i
    }
  end

  def order_params(params)
    params.permit(:completed, :page, :merchant_id, :shopper_id)
  end

  def user_params(params)
    params.permit(:name, :page, :email, :completed, :order_id)
  end

  def report_params(params)
    params.permit(:date, :merchant_id)
  end

  def disbursement_params(params)
    params.permit(:start_date, :end_date, :merchant_id, :page, :date)
  end

end
