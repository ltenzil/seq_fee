require 'rails_helper'

shared_examples_for "queryable" do
  let(:model) { described_class } # the class that includes the concern

  it "should return nil for invalid merchant query" do
    expect(model.merchant_query({ invalid: 1 })).to be_nil
  end

  it "should return merchant query" do
    expect(model.merchant_query({ merchant_id: 1 })).to eq({merchant_id: 1})
  end

  it "should return nil for invalid shopper query" do
    expect(model.shopper_query({ invalid: 1 })).to be_nil
  end

  it "should return shopper query" do
    expect(model.shopper_query({ shopper_id: 1 })).to eq({shopper_id: 1})
  end

  it "should return nil for invalid completed query" do
    expect(model.completed_query({ invalid: 1 })).to be_nil
  end

  it "should return completed query" do
    expect(model.completed_query({ completed: true })).to eq('completed_at IS NOT NULL')
  end

  it "should return nil for invalid completed query" do
    expect(model.within_query(Date.today.to_s)).to be_nil
  end

  it "should return within range query" do
    date =  Date.current
    range = date.beginning_of_week..date.end_of_week
    expect(model.within_query(range)).to eq({ completed_at: range })
  end

  it "should return within range query for given start date" do
    date =  Date.current
    range = date.beginning_of_week..date.end_of_week
    expect(model.completed_between({ start_date: date })).to eq({ completed_at: range })
  end

  it "should return within range query for given start, end date" do
    start_date = Date.current
    end_date = Date.current.end_of_month
    range = start_date.beginning_of_week..end_date
    expect(model.completed_between({ start_date: start_date, end_date: end_date })).to eq({ completed_at: range })
  end

  it "should return 0 for invalid page" do
    expect(model.page()).to eq(0)
  end

  it "should return page number for given page" do
    expect(model.page({page: "3"})).to eq(3 * QueryHelpers::PAGE_LIMIT)
    expect(model.page({page: 7})).to eq(7 * QueryHelpers::PAGE_LIMIT)
  end

  it "should return last week range with no date" do
    date_range = model.date_range()
    expect(date_range.first).to eq(Date.current.last_week.beginning_of_week)
  end

end

