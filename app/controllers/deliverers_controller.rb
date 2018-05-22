class DeliverersController < ApplicationController

  # GET /deliverers/#
  def show
    @deliverer = Deliverer.find(params[:id])
  end

  # GET /deliverers/new
  def new
    @deliverer = Deliverer.new
  end

  # POST /deliverers
  def create
    @deliverer = Deliverer.new(deliverer_params)

    if @deliverer.save
      # handle
      redirect_to @deliverer
    else
      render 'new'
    end
  end

  private
  def deliverer_params
    params.require(:deliverer).permit(:name, :phone, :vehicle, :active)
  end

end
