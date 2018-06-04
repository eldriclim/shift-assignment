require 'rails_helper'

RSpec.describe ShiftAssignmentService do
  describe '#perform' do
    Given!(:deliverers) { FactoryGirl.create_list(:deliverer, 3) }
    Given!(:shift) { FactoryGirl.create(:shift) }

    Given!(:service1) { ShiftAssignmentService.new(deliverers[0].id, shift.id) }

    context 'when deliverer or shift id is nil' do
      # Setup erroneous services
      Given!(:service_deliverer_nil) do
        ShiftAssignmentService.new(nil, shift.id)
      end
      Given!(:service_shift_nil) do
        ShiftAssignmentService.new(deliverers[0].id, nil)
      end

      Then { expect(service_deliverer_nil.perform).to eq(false) }

      And do
        expect(service_deliverer_nil.errors).to(
          include('Please create some Deliverers and Shifts first.')
        )
      end

      And { expect(service_shift_nil.perform).to eq(false) }

      And do
        expect(service_shift_nil.errors).to(
          include('Please create some Deliverers and Shifts first.')
        )
      end
    end

    context 'when Shift is already maxed out' do
      # Setup services to be assigned
      Given!(:service2) do
        ShiftAssignmentService.new(deliverers[1].id, shift.id)
      end

      Given!(:service3) do
        ShiftAssignmentService.new(deliverers[2].id, shift.id)
      end

      # Max out Shift: 0/2 -> 2/2
      When { service1.perform }
      When { service2.perform }

      Then { expect(service3.perform).to eq(false) }

      And do
        expect(service3.errors).to(
          include('Shift count has already maxed out!')
        )
      end
    end

    context 'when Assignment already exist' do
      # Add pre-existing service
      When { service1.perform }

      Then { expect(service1.perform).to eq(false) }
      And { expect(service1.errors).to include('Assignment already exist!') }
    end

    context 'when error in saving' do
      # Setup erroneous services
      Given!(:service_erroneous) { ShiftAssignmentService.new(-1, shift.id) }

      Then { expect(service_erroneous.perform).to eq(false) }

      And do
        expect(service_erroneous.errors).to(
          include('Error in assigning shift!')
        )
      end
    end

    context 'when successful' do
      Then { expect(service1.perform).to eq(true) }

      And do
        expect(service1.success).to(
          include('A new assignment has been made!')
        )
      end
    end
  end
end
