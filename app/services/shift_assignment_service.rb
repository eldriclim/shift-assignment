class ShiftAssignmentService
  attr_reader :deliverer_id, :shift_id, :errors, :success

  def initialize(deliverer_id, shift_id)
    @deliverer_id = deliverer_id
    @shift_id = shift_id
    @errors = []
    @success = []
  end

  # :reek:TooManyStatements
  # rubocop:disable AbcSize
  def perform
    # Terminate when variables are not found
    if @deliverer_id.blank? || @shift_id.blank?
      @errors << 'Please specify a Deliverer and Shift.'
      return false
    end

    # Check max count for Shift
    shift = Shift.find(shift_id)
    if shift.max?
      @errors << 'Shift count has already maxed out!'
      return false
    end

    # Check if Shift already exist
    if Assignment.exists?(deliverer_id: @deliverer_id, shift_id: @shift_id)
      @errors << 'Assignment already exist!'
      return false
    end

    assignment = Assignment.new(
      deliverer_id: @deliverer_id,
      shift_id: @shift_id
    )

    if assignment.save
      AssignmentMailer.with(
        user: Deliverer.find(@deliverer_id),
        shift: Shift.find(@shift_id),
        assignment: assignment
      ).assignment_notice.deliver_now

      @success << 'A new assignment has been made!'

      return true
    else
      @errors << 'Error in assigning shift!'

      return false
    end
  end
  # rubocop:enable AbcSize
end
