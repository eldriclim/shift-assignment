class AssignmentsController < ApplicationController

  def create
    if params[:assignment].nil?
      flash[:danger] = "Please create some Deliverers and Shifts first."
      redirect_to home_path
      return
    elsif params[:assignment][:shift_id].nil? ||
            params[:assignment][:deliverer_id].nil?
      flash[:danger] = "Please create some Deliverers and Shifts first."
      redirect_to home_path
      return
    end

    @shift = Shift.find(shift_id)
    if @shift.max_count == @shift.deliverers.count
      flash[:danger] = "Shift count has already maxed out!"
      redirect_to home_path
      return
    end

    @assignment = Assignment.new(assignment_params)

    if @assignment.save
      flash[:success] = "A new assignment has been made!"
      redirect_to home_path
      return
    else
      flash[:danger] = "Error in assigning shift!"
      redirect_to home_path
      return
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

  def assignment_params
    params.require(:assignment).permit(:deliverer_id, :shift_id)
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
