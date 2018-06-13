class AssignmentsController < ApplicationController
  def index
    @range = set_range(params)

    if @range.blank?
      flash[:danger] = 'Invalid date range!'
      redirect_to assignments_path
    end

    @shifts = retrieve_shift_in_range(@range)
  end

  def new
    @deliverers = Deliverer.order(name: :asc, phone: :asc).all
    @shifts = Shift.order(start_time: :asc).all
    @assignment = Assignment.new
  end

  def create
    if !params.has_key?(:assignment)
      flash[:danger] = 'No assignment received'
    else

      shift_assignment_service = ShiftAssignmentService.new(deliverer_id, shift_id)

      if shift_assignment_service.perform
        flash[:success] = shift_assignment_service.success

      else
        flash[:danger] = shift_assignment_service.errors
      end
    end

    redirect_to new_assignment_path
  end

  def delete
    @range = set_range(params)

    if @range.blank?
      flash[:danger] = 'Invalid date range!'
      redirect_to assignments_path
    end

    @shifts = retrieve_shift_in_range(@range)
  end

  def destroy
    unassign = Assignment.find(params[:id])

    if unassign.destroy
      flash[:success] = 'Successfully undo an assignment'
    else
      flash[:danger] = 'Error in undoing assignment!'
    end

    redirect_to delete_assignments_path(
      range1_destroy: params[:range1], range2_destroy: params[:range2]
    )
  end

  def deliverer_id
    params[:assignment][:deliverer_id]
  end

  def shift_id
    params[:assignment][:shift_id]
  end

  # :reek:UtilityFunction
  def date_format(date_string)
    "#{date_string['date(3i)']}-#{date_string['date(2i)']}" +
      "-#{date_string['date(1i)']}"
  end

  # :reek:UtilityFunction
  def compute_date_range_from_form(date_from, date_to)
    time_from = Date.parse(date_format(date_from)).at_beginning_of_day
    time_to = Date.parse(date_format(date_to)).at_end_of_day

    time_from..time_to
  end

  # :reek:UtilityFunction
  def compute_date_range_from_redirect(date_from, date_to)
    time_from = Date.parse(date_from).at_beginning_of_day
    time_to = Date.parse(date_to).at_end_of_day

    time_from..time_to
  end

  # :reek:FeatureEnvy
  def set_range(params)
    if params.has_key?(:range1) && params.has_key?(:range2)
      compute_date_range_from_form(params[:range1], params[:range2])

    elsif params.has_key?(:range1_destroy) && params.has_key?(:range2_destroy)
      compute_date_range_from_redirect(params[:range1_destroy], params[:range2_destroy])

    else
      today = Time.zone.today
      today.at_beginning_of_day..today.at_end_of_day
    end
  end

  # :reek:UtilityFunction
  def retrieve_shift_in_range(range)
    Shift.where(start_time: range).where(end_time: range)
  end
end
