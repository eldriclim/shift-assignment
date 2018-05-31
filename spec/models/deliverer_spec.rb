require 'rails_helper'

RSpec.describe Deliverer, type: :model do

  # Test association
  it { is_expected.to have_many(:assignments) }
  it { is_expected.to have_many(:shifts).through(:assignments) }

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


  # Test instance methods

  subject { Deliverer.new }

  describe '#active_helper' do
    context 'when active true' do
      it 'returns Active' do
        subject.active = true

        expect(subject.active_to_s).to eq("Active")
      end
    end

    context 'when active false' do
      it 'returns Inactive' do
        subject.active = false

        expect(subject.active_to_s).to eq("Inactive")
      end
    end

  end
end
