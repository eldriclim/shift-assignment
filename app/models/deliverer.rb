class Deliverer < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :shifts, through: :assignments

  validates :name, presence: { message: 'Name field is empty' },
                   length: { maximum: 50, message: 'Name cannot be longer than 50 characters' }
  validates :vehicle, presence: true
  validates :phone, presence: { message: 'Phone field is empty' },
                    numericality: { only_integer: true, message: 'Phone has to be an integer' },
                    uniqueness: { message: 'Phone already in used' }

  enum vehicle: { motorbike: 0, bicycle: 1, scooter: 2 }

  def active_to_s
    case active
    when true
      'Active'
    when false
      'Inactive'
    else
      'ERROR'
    end
  end
end
