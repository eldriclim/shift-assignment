class AssignmentsController < ApplicationController

  def create
    if params[:assignment].nil?
      flash[:danger] = "No assignment received"
      redirect_to home_path
      return
    else

      shift_assignment_service = ShiftAssignmentService.new(deliverer_id, shift_id)

      if shift_assignment_service.perform
        flash[:success] = shift_assignment_service.success
      else
        flash[:danger] = shift_assignment_service.errors
      end

      redirect_to home_path
    end
  end

  def show
    @start = Date.parse(date_start_format(params[:range1])) if params[:range1]
    @end = Date.parse(date_end_format(params[:range2])) if params[:range2]
    @start = @start.at_beginning_of_day
    @end = @end.at_end_of_day

    if @start > @end
      flash[:danger] = "Invalid date range!"
      redirect_to home_path
    end

    @shifts = Shift.where(start_time: @start..@end).where(end_time: @start..@end)
  end

  def deliverer_id
    params[:assignment][:deliverer_id]
  end
  def shift_id
    params[:assignment][:shift_id]
  end
  def date_start_format(date_string)
    "#{date_string['start_date(3i)']}-#{date_string['start_date(2i)']}-#{date_string['start_date(1i)']}"
  end
  def date_end_format(date_string)
    "#{date_string['end_date(3i)']}-#{date_string['end_date(2i)']}-#{date_string['end_date(1i)']}"
  end
end
