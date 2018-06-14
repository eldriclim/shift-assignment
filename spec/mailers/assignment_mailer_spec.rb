require 'rails_helper'

RSpec.describe AssignmentMailer, type: :mailer do
  Given!(:deliverer) { FactoryGirl.create(:deliverer) }
  Given!(:shift) { FactoryGirl.create(:shift) }
  Given!(:assignment) do
    FactoryGirl.create(:assignment, deliverer_id: deliverer.id, shift_id: shift.id)
  end

  describe 'assignment_notice' do
    Given!(:assign_email) do
      AssignmentMailer.with(
        user: deliverer,
        shift: shift,
        assignment: assignment
      ).assignment_notice
    end

    Then { expect(assign_email).to deliver_to(deliverer.email) }
    And { expect(assign_email).to have_subject('Notice: You have been assigned a new shift!') }
    And { expect(assign_email).to have_body_text(deliverer.name) }
    And { expect(assign_email).to have_body_text(shift.start_time_to_s) }
    And { expect(assign_email).to have_body_text(shift.end_time_to_s) }
    And { expect(assign_email).to have_body_text(assignment.id.to_s) }
  end

  describe 'unassignment_notice' do
    Given!(:unassign_email) do
      AssignmentMailer.with(
        user: deliverer,
        shift: shift,
        assignment_id: 1
      ).unassignment_notice
    end

    Then { expect(unassign_email).to deliver_to(deliverer.email) }
    And { expect(unassign_email).to have_subject('Notice: You have been unassigned a shift') }
    And { expect(unassign_email).to have_body_text(deliverer.name) }
    And { expect(unassign_email).to have_body_text(shift.start_time_to_s) }
    And { expect(unassign_email).to have_body_text(shift.end_time_to_s) }
    And { expect(unassign_email).to have_body_text(1.to_s) }
  end
end
