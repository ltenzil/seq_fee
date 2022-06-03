class Shopper < ApplicationRecord
  validates_presence_of :name, :email, :nif

  has_many :orders, dependent: :destroy

end
