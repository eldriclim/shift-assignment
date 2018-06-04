class AssignmentsController < ApplicationController
  def create
    if params[:assignment].nil?
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
  def show
    if params[:range1].nil? && params[:range2].nil?
      flash[:danger] = 'Missing date input!'
      redirect_to home_path
    end

    @range = date_range(params[:range1], params[:range2])

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

  def date_format(date_string)
    "#{date_string['date(3i)']}-#{date_string['date(2i)']}" +
      "-#{date_string['date(1i)']}"
  end

  def date_range(date1, date2)
    date_from = Date.parse(date_format(date1)).at_beginning_of_day
    date_to = Date.parse(date_format(date2)).at_end_of_day

    date_from..date_to
  end

  def retrieve_shift_in_range(range)
    Shift.where(start_time: range).where(end_time: range)
  end
end
