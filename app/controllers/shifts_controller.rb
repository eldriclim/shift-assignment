class ShiftsController < ApplicationController
  def index
    @shifts = Shift.all
  end

  def show
    @shift = Shift.find(params[:id])
  end

  def new
    @shift = Shift.new
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to home_path
    else
      errors = @shift.errors unless @shift.valid?
      
      flash[:danger] = errors.full_messages.to_sentence
      redirect_to new_shift_path
    end
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def update
    @shift = Shift.find(params[:id])
    if @shift.update_attributes(shift_params)
      redirect_to home_path
    else
      errors = @shift.errors unless @shift.valid?

      flash[:danger] = errors.full_messages.to_sentence
      redirect_to edit_shift_path
    end
  end

  private

  def shift_params
    params.require(:shift).permit(:start_time, :end_time, :max_count)
  end
end