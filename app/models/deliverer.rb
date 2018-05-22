class Deliverer < ApplicationRecord

  VAILD_PHONE_REGEX = /\d+/

  validates :name, presence: true, length: { maximum: 50, message: "Name is longer than 50 characters." }
  validates :vehicle, presence: true
  validates :phone, presence: true, format: { with: VAILD_PHONE_REGEX, message: "Only integer is allowed." }

end
