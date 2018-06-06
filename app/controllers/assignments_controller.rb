class AssignmentsController < ApplicationController
  def search
    show
    respond_to do |format|
      format.js
    end
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

    redirect_to home_path
  end

  # rubocop:disable Metrics/AbcSize
  # :reek:TooManyStatements
  # :reek:NilCheck
  # :reek:DuplicateMethodCall
  def show
    @range = if !params.has_key?(:range1) && !params.has_key?(:range2)
               Time.zone.today.at_beginning_of_day..Time.zone.today.at_end_of_day
             else
               date_range(params[:range1], params[:range2])
             end

    if @range.max == nil
      flash[:danger] = 'Invalid date range!'
      redirect_to home_path
    end

    @shifts = retrieve_shift_in_range(@range)
  end
  # rubocop:enable Metrics/AbcSize

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
  def date_range(date_from, date_to)
    time_from = Date.parse(date_format(date_from)).at_beginning_of_day
    time_to = Date.parse(date_format(date_to)).at_end_of_day

    time_from..time_to
  end

  # :reek:UtilityFunction
  def retrieve_shift_in_range(range)
    Shift.where(start_time: range).where(end_time: range)
  end
end
