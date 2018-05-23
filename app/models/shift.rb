class Shift < ApplicationRecord
  has_many :assignment
  has_many :deliverer, through: :assignment

  validates :start_time, presence: true, uniqueness: { scope: :end_time, message: "shift already exist" }
  validates :end_time, presence: true
  validate :start_before_end

  validates :max_count, presence: true
  validates_numericality_of :max_count,
      only_integer: true, message: "only integer is allowed"
  validates_numericality_of :max_count,
      greater_than_or_equal_to: 1, message: "max count has to be greater than 0"

  def start_before_end
    if end_time < start_time
      errors.add(:start_time, "start time cannot be after end time")
    elsif end_time == start_time
      errors.add(:start_time, "start time and end time cannot be the same")
    end

  end
end
