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





  # describe "Deliverer model" do
  #   subject { described_class.new(name: "Name", vehicle: 0, phone: 123) }
  #
  #   context "all attributes" do
  #     it "has to be present" do
  #       expect(subject).to be_valid
  #     end
  #   end
  #
  #   context "name attribute" do
  #     it "has to be present" do
  #       subject.name = nil
  #       expect(subject).to_not be_valid
  #     end
  #
  #     it "cannot be longer than 50 chars" do
  #       subject.name = "Fiftyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
  #       expect(subject).to_not be_valid
  #     end
  #   end
  #
  #   context "vehicle attribute" do
  #     it "has to be present" do
  #       subject.vehicle = nil
  #       expect(subject).to_not be_valid
  #     end
  #   end
  #
  #   context "phone attribute" do
  #     it "has to be present" do
  #       subject.phone = nil
  #       expect(subject).to_not be_valid
  #     end
  #
  #     it "has to be an integer" do
  #       subject.phone = "phone"
  #       expect(subject).to_not be_valid
  #     end
  #   end
  # end
end
