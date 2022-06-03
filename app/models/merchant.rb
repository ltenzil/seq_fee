class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy
end
