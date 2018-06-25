class AvailableShiftsApi
  def initialize(from_input, to_input)
    @from_input = from_input
    @to_input = to_input
  end

  # :reek:TooManyStatements
  # :reek:NilCheck
  def perform
    # Catch invalid input
    begin
      range = Date.parse(@from_input).at_beginning_of_day..Date.parse(@to_input).at_end_of_day
    rescue ArgumentError
      return { status: 'Error: Invalid arguments' }
    end

    return { status: 'Error: Invalid date range' } if range.max.nil?

    # Extract shifts in range
    shifts = Shift.where(start_time: range).where(end_time: range)
    shifts = shifts.reject(&:max?)

    { status: 'OK', shifts: shifts }
  end
end
