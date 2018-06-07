class DeliverersController < ApplicationController
  # GET /deliverers/index
  # :reek:UncommunicativeVariableName
  def index
    @query = Deliverer.ransack(params[:query])

    @deliverer = Deliverer.new
    @deliverers = Deliverer.all
  end

  # GET /deliverers/search
  # :reek:DuplicateMethodCall
  # :reek:UncommunicativeVariableName
  def search
    @query = Deliverer.ransack(params[:query])
    @query.sorts = 'id asc' if @query.sorts.empty?

    @deliverers = @query.result(distinct: true)
    # if check_search_condition(params)
    #   flash[danger] = 'Invalid input!'
    #   redirect_to deliverers_path
    # end
    #
    # service = DeliverersFilterService.new(params[:deliverer])
    # @deliverers = service.perform
  end

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
      flash[:success] = 'Successfully updated a deliverer!'

      redirect_to deliverers_path
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

  def check_search_condition(params)
    return false if params.has_key?(:deliverer)

    deliverer_params = params[:deliverer]

    if !deliverer_params.has_key?(:name) || !deliverer_params.has_key?(:phone) ||
       !deliverer_params.has_key?(:vehicle) || !deliverer_params.has_key?(:active)
      false
    else
      true
    end
  end
end
