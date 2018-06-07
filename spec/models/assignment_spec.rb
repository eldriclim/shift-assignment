require 'rails_helper'

RSpec.describe Assignment, type: :model do

  # Test association
  it { is_expected.to belong_to(:deliverer) }
  it { is_expected.to belong_to(:shift) }

  # Test IDs
  it {
    is_expected.to validate_uniqueness_of(:deliverer_id).scoped_to(:shift_id).
      with_message("Assignment already exist") 
  }

end
