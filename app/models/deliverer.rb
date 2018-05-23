class Deliverer < ApplicationRecord
  has_many :assignment
  has_many :shift, through: :assignment

  VAILD_PHONE_REGEX = /\d+/

  validates :name, presence: true, length: { maximum: 50, message: "name is longer than 50 characters." }
  validates :vehicle, presence: true
  validates :phone, presence: true, numericality: { only_integer: true, message: "only integer is allowed." }, uniqueness: { message: "phone already in used." }

end
