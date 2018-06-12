class ShiftsController < ApplicationController
  def index
    @limit = set_page_limit(params)

    @shifts = Shift.all.order('start_time ASC').page(params[:page]).per(@limit)
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
      redirect_to new_shift_path
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

  def set_page_limit(params)
    if params.has_key?(:limit)
      params[:limit]
    else
      25
    end
  end
end
