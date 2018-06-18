class Assignment < ApplicationRecord
  belongs_to :deliverer, counter_cache: :shifts_count
  belongs_to :shift, counter_cache: :deliverers_count

  validates :deliverer_id, uniqueness: { scope: :shift_id, message: 'Assignment already exist' }
end
