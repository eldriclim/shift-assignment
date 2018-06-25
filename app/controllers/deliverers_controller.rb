class DeliverersController < ApplicationController
  # GET /deliverers
  def index
    @deliverers = Deliverer.all
  end

  # GET /deliverers/show
  # :reek:TooManyStatements
  # rubocop:disable Metrics/AbcSize
  def show
    @deliverer = Deliverer.find(params[:id])
    today = Time.zone.today
    @range = (today - 29).at_beginning_of_day..today.at_end_of_day

    shifts = @deliverer.shifts.where(start_time: @range).order('start_time ASC')

    @shift_groups = shifts.group_by { |shf| (shf.start_time.to_date - @range.begin.to_date).to_i }
  end
  # rubocop:enable Metrics/AbcSize

  # GET /deliverers/new
  # page to add
  def new
    @deliverer = Deliverer.new
  end

  # POST /deliverers
  # :reek:TooManyStatements
  def create
    @deliverer = Deliverer.new(deliverer_params)

    if @deliverer.save
      flash[:success] = 'Successfully created a new deliverer!'

      redirect_to deliverers_path

    else
      errors = @deliverer.errors unless @deliverer.valid?

      flash[:danger] = errors.full_messages

      redirect_to new_deliverer_path
    end
  end

  # GET /deliverers/#/edit
  # page to edit
  def edit
    @deliverer = Deliverer.find(params[:id])
  end

  # PATCH /deliverers/#
  # :reek:TooManyStatements
  def update
    @deliverer = Deliverer.find(params[:id])

    if @deliverer.update(deliverer_params)
      flash[:success] = 'Successfully updated deliverer\'s info!'

      redirect_to deliverer_path(params[:id])
    else
      errors = @deliverer.errors unless @deliverer.valid?

      flash[:danger] = errors.full_messages

      redirect_to edit_deliverer_path
    end
  end

  private

  def deliverer_params
    params.require(:deliverer).permit(:name, :phone, :vehicle, :active)
  end
end
