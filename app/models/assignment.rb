class Assignment < ApplicationRecord
  belongs_to :deliverer
  belongs_to :shift

  validates :deliverer_id,
      uniqueness: { scope: :shift_id, message: "assignment already exist"}
end
