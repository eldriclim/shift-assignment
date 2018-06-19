class ShiftsController < ApplicationController
  skip_before_action :authenticate_user!, only: :available_shifts

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

  def available_shifts
    if !params.has_key?(:start_time) || !params.has_key?(:end_time)
      render json: { status: 'Error: Missing arguments' }
      return
    end

    api = AvailableShiftsApi.new(params[:start_time], params[:end_time])
    render json: api.perform, except: [:created_at, :updated_at]
  end

  private

  def shift_params
    params.require(:shift).permit(:start_time, :end_time, :max_count)
  end
end
