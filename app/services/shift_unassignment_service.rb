class ShiftUnassignmentService
  attr_reader :errors, :success

  def initialize(id)
    @assignment_id = id
    @success = []
    @errors = []
  end

  # :reek:TooManyStatements
  def perform
    begin
      unassign = Assignment.find(@assignment_id)
    rescue ActiveRecord::RecordNotFound
      @errors << 'Assignment does not exist!'

      return false
    end

    deliverer = unassign.deliverer
    shift = unassign.shift

    if unassign.destroy
      @success << 'Successfully undo an assignment'

      AssignmentMailer.with(
        user: deliverer,
        shift: shift,
        assignment_id: @assignment_id
      ).unassignment_notice.deliver_later

      return true
    else
      @errors << 'Error in undoing assignment!'
      return false
    end
  end
end
