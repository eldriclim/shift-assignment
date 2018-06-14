require 'rails_helper'

RSpec.describe ShiftUnassignmentService do
  describe '#perform' do
    Given!(:deliverer) { FactoryGirl.create(:deliverer) }
    Given!(:shift) { FactoryGirl.create(:shift) }
    Given!(:assignment) do
      FactoryGirl.create(:assignment,
                         shift_id: shift.id,
                         deliverer_id: deliverer.id)
    end

    context 'when unsuccessful destroy' do
      context 'assignment not found' do
        Given(:unassign_service_error_id) { ShiftUnassignmentService.new(-1) }

        Then { expect(unassign_service_error_id.perform).to eq false }
        And { expect(unassign_service_error_id.errors).to include 'Assignment does not exist!' }
      end

      context 'unable to destroy' do
        Given(:unassign_service) { ShiftUnassignmentService.new(assignment.id) }
        Given do
          allow(Assignment).to receive(:find).and_return(assignment)
          allow(assignment).to receive(:destroy).and_return(false)
        end

        Then { expect(unassign_service.perform).to eq false }
        And { expect(unassign_service.errors).to include 'Error in undoing assignment!' }
      end
    end

    context 'when sucessful destroy' do
      Given(:unassign_service) { ShiftUnassignmentService.new(assignment.id) }

      Then { expect(unassign_service.perform).to eq true }
      And { expect(unassign_service.success).to include 'Successfully undo an assignment' }
    end
  end
end
