class ShiftsController < ApplicationController
  def index
    @shifts = Shift.all
  end

  def new
    @shift = Shift.new
  end

  # :reek:TooManyStatements
  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      flash[:success] = 'Successfully created a new shift!'
      redirect_to shifts_path
    else
      errors = @shift.errors unless @shift.valid?

      flash[:danger] = errors.full_messages

      redirect_to new_shift_path(shift_params)
    end
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  # :reek:TooManyStatements
  def update
    @shift = Shift.find(params[:id])
    if @shift.update(shift_params)
      flash[:success] = 'Successfully updated a shift!'
      redirect_to shifts_path
    else
      errors = @shift.errors unless @shift.valid?

      flash[:danger] = errors.full_messages

      redirect_to edit_shift_path
    end
  end

  private

  def shift_params
    params.require(:shift).permit(:start_time, :end_time, :max_count)
  end
end
