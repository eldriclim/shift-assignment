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
      redirect_to shifts_path
    else
      render 'new'
    end
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def update
    @shift = Shift.find(params[:id])
    if @shift.update_attributes(shift_params)
      redirect_to shifts_path
    else
      render 'edit'
    end
  end

  private

  def shift_params
    params.require(:shift).permit(:start_time, :end_time, :max_count)
  end
end
