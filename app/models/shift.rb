class Shift < ApplicationRecord
  has_many :assignment
  has_many :deliverer, through: :assignment

  validates :start_time, presence: true,
      uniqueness: { scope: :end_time, message: "Shift already exist" }
  validates :end_time, presence: true
  validate :start_before_end

  validates :max_count, presence: { message: "Max count field is empty" }
  validates_numericality_of :max_count,
      only_integer: true, message: "Max count has to be an integer"
  validates_numericality_of :max_count,
      greater_than_or_equal_to: 1, message: "Max count has to be greater than 0"

  def start_before_end
    if end_time < start_time
      errors.add(:start_time, "Start time cannot be after End time")
    elsif end_time == start_time
      errors.add(:start_time, "Start time and End time cannot be the same")
    end

  end
end
