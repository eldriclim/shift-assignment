# :reek:TooManyInstanceVariables
class DeliverersController < ApplicationController
  # GET /deliverers/index
  # :reek:UncommunicativeVariableName
  def index
    @limit = set_page_limit(params)

    @query_params = params[:query]

    @query = Deliverer.ransack(@query_params)

    @query.sorts = 'id asc' if @query.sorts.empty?

    @deliverers = @query.result(distinct: true).order('id ASC').
      page(params[:page]).per(@limit)
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

  def set_page_limit(params)
    if params.has_key?(:limit)
      params[:limit]
    else
      25
    end
  end
end
