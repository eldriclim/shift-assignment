class Shift < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :deliverers, through: :assignments

  validates :start_time, presence: true,
                         uniqueness: { scope: :end_time, message: 'Shift already exist' }
  validates :end_time, presence: true
  validate :start_before_end

  validates :max_count,
            presence: { message: 'Max count field is empty' }

  validates :max_count,
            numericality: { only_integer: true, message: 'Max count has to be an integer' }
  validates :max_count,
            numericality: {
              greater_than_or_equal_to: 1,
              message: 'Max count has to be greater than 0'
            }

  def start_before_end
    if start_time.nil? || end_time.nil?
      return
    end

    if end_time < start_time
      errors.add(:start_time, 'Start time cannot be after End time')
    elsif end_time == start_time
      errors.add(:start_time, 'Start time and End time cannot be the same')
    end
  end

  def start_time_to_s
    start_time.strftime('%Y-%m-%d %T')
  end

  def end_time_to_s
    end_time.strftime('%Y-%m-%d %T')
  end

  def max?
    max_count == deliverers.count
  end
end
