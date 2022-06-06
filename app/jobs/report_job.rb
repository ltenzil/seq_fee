require './lib/disburse/report'

class ReportJob < ApplicationJob

  rescue_from Exception do |exception, _job|
    Rails.logger.info "Unable to run report for parameters: #{arguments}"
    Rails.logger.info exception.backtrace
  end

  def perform(options = {})
    Rails.logger.info "Generate Report for parameters: #{options}"
    report = Disburse::Report.generate(options)
    Rails.logger.info 'Report Generated Successfully'
    if report.orders.blank?
      Rails.logger.info 'No results to display'
    else
      Rails.logger.info 'Creating Disbursements'
      records = Disbursement.add_orders(report.orders)
      Rails.logger.info 'Disbursements Created Successfully'
      records
    end
  end

end
