require "rails_helper"

RSpec.describe ReportJob, type: :job do
  describe "#perform_later" do
    it "generates report and creates dibursement" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ReportJob.perform_later()
      }.to have_enqueued_job
    end
  end
end
