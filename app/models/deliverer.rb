class Deliverer < ApplicationRecord

  VAILD_PHONE_REGEX = /\d+/

  validates :name, presence: true, length: { maximum: 50 }
  validates :vehicle, presence: true
  validates :phone, presence: true, format: { with: VAILD_PHONE_REGEX }, uniqueness: true
  validates :active, presence: true

end
