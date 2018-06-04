class Shift < ApplicationRecord
  has_many :assignments
  has_many :deliverers, through: :assignments

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
    unless start_time.nil? || end_time.nil?
      if end_time < start_time
        errors.add(:start_time, "Start time cannot be after End time")
      elsif end_time == start_time
        errors.add(:start_time, "Start time and End time cannot be the same")
      end
    end
  end

  def start_time_to_s
    start_time.strftime("%Y-%m-%d %T")
  end

  def end_time_to_s
    end_time.strftime("%Y-%m-%d %T")
  end

  def max?
    self.max_count == self.deliverers.count
  end
end
