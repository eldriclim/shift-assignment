class AssignmentsController < ApplicationController

  def create
    @shift = Shift.find(shift_id)
    if @shift.max_count == @shift.deliverer.count
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

  def assignment_params
    params.require(:assignment).permit(:deliverer_id, :shift_id)
  end
  def shift_id
    params[:assignment][:shift_id]
  end
end
