require 'rails_helper'

RSpec.describe ShiftAssignmentService do

  describe "#perform" do
    before do
      @deliverers = FactoryGirl.create_list(:deliverer,3)
      @shift = FactoryGirl.create(:shift)

      @service1 = ShiftAssignmentService.new(@deliverers[0].id, @shift.id)
    end

    subject { ShiftAssignmentService.new }

    context "when deliverer or shift id is nil" do
      before do
        # Setup erroneous services
        @service_deliverer_nil = ShiftAssignmentService.new(nil, @shift.id)
        @service_shift_nil = ShiftAssignmentService.new(@deliverers[0].id, nil)
      end

      it "adds to errors" do

        expect(@service_deliverer_nil.perform).to eq(false)
        expect(@service_deliverer_nil.errors).to include("Please create some Deliverers and Shifts first.")

        expect(@service_shift_nil.perform).to eq(false)
        expect(@service_shift_nil.errors).to include("Please create some Deliverers and Shifts first.")

      end
    end

    context "when Shift is already maxed out" do
      before do
        # Setup services to be assigned
        @service2 = ShiftAssignmentService.new(@deliverers[1].id, @shift.id)
        @service3 = ShiftAssignmentService.new(@deliverers[2].id, @shift.id)

        # Max out Shift: 0/2 -> 2/2
        @service1.perform
        @service2.perform
      end

      it "adds to error" do
        expect(@service3.perform).to eq(false)
        expect(@service3.errors).to include("Shift count has already maxed out!")
      end
    end

    context "when Assignment already exist" do
      before do
        # Add pre-existing service
        @service1.perform
      end

      it "adds to error" do
        expect(@service1.perform).to eq(false)
        expect(@service1.errors).to include("Assignment already exist!")
      end
    end

    context "when error in saving" do
      before do
        # Setup erroneous services
        @service_erroneous = ShiftAssignmentService.new(-1, @shift.id)
      end

      it "adds to error" do
        expect(@service_erroneous.perform).to eq(false)
        expect(@service_erroneous.errors).to include("Error in assigning shift!")

      end
    end

    context "when successful" do
      it "adds to success" do
        expect(@service1.perform).to eq(true)
        expect(@service1.success).to include("A new assignment has been made!")
      end
    end
  end


end
