class Deliverer < ApplicationRecord
  has_many :assignment
  has_many :shift, through: :assignment

  validates :name, presence: { message: "Name field is empty" },
      length: { maximum: 50, message: "Name cannot be longer than 50 characters" }
  validates :vehicle, presence: true
  validates :phone, presence: { message: "Phone field is empty" },
      numericality: { only_integer: true, message: "Phone has to be an integer" },
      uniqueness: { message: "Phone already in used" }

      def vehicle_to_s
        case self.vehicle
        when 0
          "Motorbike"
        when 1
          "Bicycle"
        when 2
          "Scooter"
        else
          "ERROR"
        end
      end

      def active_to_s
        case self.active
        when true
          "Active"
        when false
          "Inactive"
        else
          "ERROR"
        end
      end
end
