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

    if unassign.destroy
      @success << 'Successfully undo an assignment'
      return true
    else
      @errors << 'Error in undoing assignment!'
      return false
    end
  end
end
