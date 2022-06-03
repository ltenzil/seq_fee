class Order < ApplicationRecord
  validates_presence_of :amount
  
  belongs_to :merchant
  belongs_to :shopper

  scope :completed, -> { where.not(completed_at: nil) }

end
