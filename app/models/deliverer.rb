class Deliverer < ApplicationRecord
  has_many :assignment
  has_many :shift, through: :assignment

  VAILD_PHONE_REGEX = /\d+/

  validates :name, presence: { message: "Name field is empty" },
      length: { maximum: 50, message: "Name cannot be longer than 50 characters" }
  validates :vehicle, presence: true
  validates :phone, presence: { message: "Phone field is empty" },
      numericality: { only_integer: true, message: "Phone has to be an integer" },
      uniqueness: { message: "Phone already in used" }

end
