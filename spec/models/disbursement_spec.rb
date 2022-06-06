require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe 'Associations' do
    it "should belongs to merchant" do
      model = Disbursement.reflect_on_association(:merchant)
      expect(model.macro).to eq(:belongs_to)
    end

    it "should belongs to order" do
      model = Disbursement.reflect_on_association(:order)
      expect(model.macro).to eq(:belongs_to)
    end

    it "should get merchant , shopper, order" do
      merchant = create(:merchant)
      shopper = create(:shopper)
      order = create(:order, :complete, merchant: merchant, shopper: shopper)
      disbursement = create(:disbursement, order: order, merchant: merchant)
      expect(disbursement.merchant).to eq(merchant)
      expect(disbursement.order).to eq(order)
    end
  end

  describe "Query helpers" do
    it_behaves_like 'queryable'
  end

  describe "Validations" do
    it "should not create disbursement for incomplete orders" do
      merchant = create(:merchant)
      shopper = create(:shopper)
      order = create(:order, merchant: merchant, shopper: shopper)
      disbursement = build(:disbursement, order: order, merchant: merchant)
      expect(disbursement).to be_invalid
    end
  end

  describe "search disbursements" do
    let!(:merchant) { create(:merchant) }
    let!(:merchant2) { create(:merchant, name: "Peter merchant") }
    let!(:shopper) { create(:shopper) }
    
    let!(:order) { create(:order, :complete, merchant: merchant, shopper: shopper) }
    let!(:order2) { create(:order, :complete, merchant: merchant2, shopper: shopper) }
    let!(:order3) { create(:order, :complete, merchant: merchant, shopper: shopper, completed_at: 10.day.ago) }
    
    let!(:disbursement) { create(:disbursement, order: order, merchant: merchant) }
    let!(:disbursement2) { create(:disbursement, order: order2, merchant: merchant2) }
    let!(:disbursement3) { create(:disbursement, order: order3, merchant: merchant) }
    
    it "should return all records when merchant not given" do
      result = Disbursement.search()
      expect(result.map(&:id)).to eq([disbursement.id, disbursement2.id, disbursement3.id])
      expect(result.map(&:order_id)).to eq([order.id, order2.id, order3.id])
    end

    it "should search records by merchant " do
      result = Disbursement.search({ merchant_id: merchant2.id })
      expect(result.map(&:id)).to eq([disbursement2.id])
      expect(result.map(&:order_id)).to eq([order2.id])
    end

    it "should search records by this week " do
      result = Disbursement.search({ start_date: Date.current })
      expect(result.map(&:id)).to eq([disbursement.id, disbursement2.id])
      expect(result.map(&:order_id)).to eq([order.id, order2.id])
    end
  end
end
