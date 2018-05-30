require 'rails_helper'

RSpec.describe Deliverer, type: :model do

  # Test association
  it { is_expected.to have_many(:assignment) }
  it { is_expected.to have_many(:shift).through(:assignment) }

  # Test Name attribute
  it { is_expected.to validate_presence_of(:name).
    with_message("Name field is empty") }
  it { is_expected.to validate_length_of(:name).is_at_most(50).
    with_message("Name cannot be longer than 50 characters") }

  # Test Vehicle attribute
  it { is_expected.to validate_presence_of(:vehicle) }

  # Test Phone attribute
  it { is_expected.to validate_presence_of(:phone).
    with_message("Phone field is empty") }
  it { is_expected.to validate_numericality_of(:phone).only_integer.
    with_message("Phone has to be an integer") }
  it { is_expected.to validate_uniqueness_of(:phone).
    with_message("Phone already in used") }


    # describe '#vehicle_to_s' do
    #   context 'input 0' do
    #     it 'returns Motorbike' do
    #       debugger
    #       expect(helper.vehicle_helper(0)).to eq("Motorbike")
    #     end
    #   end
    #
    #   context 'input 1' do
    #     it 'returns Bicycle' do
    #       expect(helper.vehicle_helper(1)).to eq("Bicycle")
    #     end
    #   end
    #
    #   context 'input 2' do
    #     it 'returns Scooter' do
    #       expect(helper.vehicle_helper(2)).to eq("Scooter")
    #     end
    #   end
    # end
    # 
    # describe '#active_helper' do
    #   context 'input true' do
    #     it 'returns Active' do
    #       expect(helper.active_helper(true)).to eq("Active")
    #     end
    #   end
    #
    #   context 'input false' do
    #     it 'returns Inactive' do
    #       expect(helper.active_helper(false)).to eq("Inactive")
    #     end
    #   end
    #
    # end
end
