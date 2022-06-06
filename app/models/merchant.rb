class Merchant < ApplicationRecord
  validates_presence_of :name, :email, :cif

  has_many :orders, dependent: :destroy

end
