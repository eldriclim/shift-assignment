class Shift < ApplicationRecord
  has_many :assignment
  has_many :deliverer, through: :assignment

end
