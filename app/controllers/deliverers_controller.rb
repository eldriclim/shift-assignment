class DeliverersController < ApplicationController
  # GET /deliverers/new
  # page to add
  def new
    @deliverer = Deliverer.new
  end

  # POST /deliverers
  def create
    @deliverer = Deliverer.new(deliverer_params)

    if @deliverer.save
      redirect_to home_path

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
  def update
    @deliverer = Deliverer.find(params[:id])
    if @deliverer.update(deliverer_params)
      redirect_to home_path
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
